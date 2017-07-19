//
//  ContactSynchronizer.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/17/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation
import CoreData

let syncQueue = DispatchQueue(label: "syncQueue", attributes: [])
let syncGroup = DispatchGroup()

struct ContactSynchronizer {
//    var managedObjectContext:NSManagedObjectContext
    let persistentContainer:NSPersistentContainer
    var coreDataManager:CoreDataManager
    
    init(persistentContainer:NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.coreDataManager = CoreDataManager(persistentContainer: self.persistentContainer)
    }
    
    func sync(_ completion: @escaping () -> Void) {
        // ensure that only one sync can happen at a time by dispatching to a serial queue
        syncQueue.async {
            syncGroup.enter()
            self.uploadSync {
                self.downloadSync {
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "lastSyncAttempt")
                    self.coreDataManager.saveContext()
                    completion()
                    print("called")
                    syncGroup.leave()
                }
            }
            
            // block syncQueue until latest sync request finished
            syncGroup.wait(timeout: DispatchTime.distantFuture)
//            print("test")
        }
    }
    
    func downloadSync(_ completionBlock: @escaping () -> Void) -> Void {
        print("download sync")
        APIManager.shared.fetchContacts { (jsonDict) in
            if let dicts = jsonDict {
                var contacts = [Contact]()
                let localContacts = self.coreDataManager.allContacts()
                // if contacts are still empty, insert into coredata
                if localContacts.count == 0 {
                    dicts.forEach { dict in
                        let contact = Contact(context: self.persistentContainer.viewContext)
                        contact.configureWithJSONDictionary(dict)
                        contacts.append(contact)
                    }
                    self.coreDataManager.saveContext()
                }
                
                
//                dicts.forEach { dict in
//                    // check if server data is newer than local
//                    APIManager.shared.fetchContactDetailWithId((dict["id"] as? Int) ?? 0, completion: { (jsonDict) in
//                        let localContact = self.coreDataManager.contactWithId((dict["id"] as? String) ?? "0")
//                        if let json = jsonDict, let local = localContact {
//                            // First compare the last update value
//                            var needsUpdate = false
//                            let localLastUpdate = localContact?.updatedAt as Date?
//                            if localLastUpdate == nil {
//                                // update local
//                                needsUpdate = true
//                            }
//                            let todayDate = Date()
//                            let serverLastUpdate = (json["updated_at"] as? String)?.convertToDate() ?? todayDate
//                            let localDate = localLastUpdate as Date? ?? todayDate
//                            if serverLastUpdate.timeIntervalSince1970 > localDate.timeIntervalSince1970 {
//                                // Update local
//                                needsUpdate = true
//                            }
//                            
//                            if needsUpdate {
//                                local.isFavorite = (dict["favorite"] as? NSNumber)?.boolValue ?? false
//                                local.firstName = dict["first_name"] as? String
//                                local.lastName = dict["last_name"] as? String
//                                local.url = dict["url"] as? String
//                                local.profilePic = dict["profile_pic"] as? String
//                                local.phoneNumber = dict["phone_number"] as? String
//                                local.email = dict["email"] as? String
//                                local.createdAt = (dict["created_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
//                                local.updatedAt = (dict["updated_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
//                            }
//                            self.coreDataManager.saveContext()
//                        }
//                    })
//                }
            }
            completionBlock()
            return
        }
    }
    
    
    
    func uploadSync(_ completionBlock: @escaping () -> ()) {
        let (createContactRequests, updateContactRequests) = generateUploadRequests()
        let uploadGroup = DispatchGroup()
        
        for request in createContactRequests {
            print("UPLOAD SYNCING")
            uploadGroup.enter()
            request.performAdd(with: { (jsonDict) in
                if let dict = jsonDict {
                    // select uploaded contact from local db
                    if let localContact = self.coreDataManager.persistentContainer.viewContext.object(with: request.contact.objectID) as? Contact {
                        // assign id from server
                        localContact.id = dict["id"] as? Int32 ?? 0
                        if let updatedDate = (dict["updated_at"] as? String)?.convertServerTimeToDate() {
                            localContact.updatedAt = Int64(updatedDate.timeIntervalSince1970)
                            print("server update time \(updatedDate)")
                        }

                        self.coreDataManager.saveContext()
                    }
                }
                uploadGroup.leave()
            })
        }
        
        for request in updateContactRequests {
            uploadGroup.enter()
            request.performUpdate(with: { (jsonDict) in
                if let dict = jsonDict {
                    // select uploaded contact from local db
                    if let localContact = self.coreDataManager.persistentContainer.viewContext.object(with: request.contact.objectID) as? Contact {
                        // update last updated time
                        if let updatedDate = (dict["updated_at"] as? String)?.convertServerTimeToDate() {
                            localContact.updatedAt = Int64(updatedDate.timeIntervalSince1970)
                            print("server update time \(updatedDate)")
                        }
                        
                        self.coreDataManager.saveContext()
                    }
                }
                uploadGroup.leave()
            })
        }
        
        DispatchQueue.global(qos: .default).async {
            uploadGroup.wait(timeout: DispatchTime.distantFuture)
            
            DispatchQueue.main.async {
                completionBlock()
            }
        }
    }
    
    func generateUploadRequests() -> (createContactRequests:[ContactManagerAddRequest], updateContactRequest:[ContactManagerUpdateRequest]) {
        let contactsToPost = coreDataManager.unsyncedContacts()
        let postRequests = contactsToPost.map { APIManager.shared.createAddContactRequest($0) }
        
        let lastSyncTimeStamp = coreDataManager.lastSyncAttempt() ?? 0
        let contactsToUpdate = coreDataManager.contactsThatChangedSince(lastSyncTimeStamp)
        let putRequests = contactsToUpdate.map { APIManager.shared.createUpdateContactRequest($0) }
        
        return (postRequests, putRequests)
    }
}

//extension Date {
//    
//}


//extension Date {
//    
//}
