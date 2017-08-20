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
                    completion()
                    syncGroup.leave()
                }
            }
            
            // block syncQueue until latest sync request finished
            syncGroup.wait(timeout: DispatchTime.distantFuture)
        }
    }
    
    func downloadSync(_ completionBlock: @escaping () -> Void) -> Void {
        APIManager.shared.fetchContacts { (jsonDict) in
            DispatchQueue.main.async {
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
                        
                        dicts.forEach { dict in
                            // check if server data is newer than local
                            let id = (dict["id"] as? NSNumber)?.intValue ?? 0
                            APIManager.shared.fetchContactDetailWithId(id, completion: { (jsonDict) in
                                let localContact = self.coreDataManager.contactWithId(id)
                                if let json = jsonDict, let _ = localContact {
                                    localContact?.configureWithJSONDictionary(json, isUpdate: true)
                                }
                            })
                            self.coreDataManager.saveContext()
                        }
                        completionBlock()
                    }
                    else {
                        completionBlock()
                    }
                }
                return
            }
        }
    }
    
    
    
    func uploadSync(_ completionBlock: @escaping () -> ()) {
        let (createContactRequests, updateContactRequests) = generateUploadRequests()
        let uploadGroup = DispatchGroup()
        for request in createContactRequests {
            uploadGroup.enter()
            request.performAdd(with: { (jsonDict) in
                if let dict = jsonDict {
                    let context = self.coreDataManager.persistentContainer.newBackgroundContext()
                    // select uploaded contact from local db
                    if let localContact = context.object(with: request.contact.objectID) as? Contact {
                        // assign id from server
                        localContact.id = (dict["id"] as? NSNumber)?.int32Value ?? 0
                        
                        do {
                            try context.save()
                        }
                        catch {
                            print("error updating id")
                        }
                    }
//                    })
                }
                uploadGroup.leave()
            })
        }
        for request in updateContactRequests {
            uploadGroup.enter()
            request.performUpdate(with: { (jsonDict) in
                if let dict = jsonDict {
                    // select uploaded contact from local db
                    let context = self.coreDataManager.persistentContainer.newBackgroundContext()
                    if let localContact = context.object(with: request.contact.objectID) as? Contact {
                        // update last updated time
                        if let updatedDate = (dict["updated_at"] as? String)?.convertServerTimeToDate() {
                            localContact.updatedAt = Int64(updatedDate.timeIntervalSince1970)
                        }
                        
                        do {
                            try context.save()
                        }
                        catch {
                            print("error updating detail")
                        }
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
    
    func syncDownloadSingleContactWithId(_ id:Int, completion: @escaping (Contact?) -> Void) {
        ContactManagerDetailRequest(id: id).performFetch { (json) in
            DispatchQueue.main.async {
                let localContact = self.coreDataManager.contactWithId(id)
                if let dict = json, let contact = localContact {
                    contact.configureWithJSONDictionary(dict, isUpdate: true)
                }
                self.coreDataManager.saveContext()
                // return newly synced data
                completion(self.coreDataManager.contactWithId(id))
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

