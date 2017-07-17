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
    var managedObjectContext:NSManagedObjectContext
    var coreDataManager:CoreDataManager
    
    init(managedObjectContext:NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        self.coreDataManager = CoreDataManager(context: self.managedObjectContext)
    }
    
    func sync(_ completion: @escaping () -> Void) {
        // ensure that only one sync can happen at a time by dispatching to a serial queue
        syncQueue.async {
            syncGroup.enter()
            
            self.uploadSync {
                self.downloadSync {
                    UserDefaults.standard.set(Date.timeIntervalSinceReferenceDate, forKey: "lastSyncAttempt")
                    try? self.managedObjectContext.save()
                    completion()
                    syncGroup.leave()
                }
            }
            
            // block syncQueue until latest sync request finished
            syncGroup.wait(timeout: DispatchTime.distantFuture)
            print("test")
        }
    }
    
    func downloadSync(_ completionBlock: @escaping () -> Void) -> Void {
        APIManager.shared.fetchContacts { (jsonDict) in
            if let dicts = jsonDict {
                var contacts = [Contact]()
                dicts.forEach { dict in
                    let contact = Contact(context: self.managedObjectContext)
                    contact.id = (dict["id"] as? Int32) ?? 0
                    contact.isFavorite = (dict["favorite"] as? NSNumber)?.boolValue ?? false
                    contact.firstName = dict["first_name"] as? String
                    contact.lastName = dict["last_name"] as? String
                    contact.url = dict["url"] as? String
                    contact.profilePic = dict["profile_pic"] as? String
                    contact.phoneNumber = dict["phone_number"] as? String
                    contact.email = dict["email"] as? String
                    contact.createdAt = (dict["created_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
                    contact.updatedAt = (dict["updated_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
                    contacts.append(contact)
                }
                try? self.managedObjectContext.save()
                
                dicts.forEach { dict in
                    // check if server data is newer than local
                    APIManager.shared.fetchContactDetailWithId((dict["id"] as? Int) ?? 0, completion: { (jsonDict) in
                        let localContact = self.coreDataManager.contactWithId((dict["id"] as? String) ?? "0")
                        if let json = jsonDict, let local = localContact {
                            // First compare the last update value
                            var needsUpdate = false
                            let localLastUpdate = localContact?.updatedAt as Date?
                            if localLastUpdate == nil {
                                // update local
                                needsUpdate = true
                            }
                            let todayDate = Date()
                            let serverLastUpdate = (json["updated_at"] as? String)?.convertToDate() ?? todayDate
                            let localDate = localLastUpdate as Date? ?? todayDate
                            if serverLastUpdate.timeIntervalSince1970 > localDate.timeIntervalSince1970 {
                                // Update local
                                needsUpdate = true
                            }
                            
                            if needsUpdate {
                                local.isFavorite = (dict["favorite"] as? NSNumber)?.boolValue ?? false
                                local.firstName = dict["first_name"] as? String
                                local.lastName = dict["last_name"] as? String
                                local.url = dict["url"] as? String
                                local.profilePic = dict["profile_pic"] as? String
                                local.phoneNumber = dict["phone_number"] as? String
                                local.email = dict["email"] as? String
                                local.createdAt = (dict["created_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
                                local.updatedAt = (dict["updated_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
                            }
                            try? self.managedObjectContext.save()
                        }
                    })
                }
            }
        }
    }
    
    
    
    func uploadSync(_ completionBlock: @escaping () -> ()) {
        completionBlock()
    }
}

import UIKit
//extension Date {
//    
//}

extension String {
    func convertToDate(_ format:String = "yyyy-MM-ddThh:mm:ssZ") -> Date? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dateFormatter:DateFormatter
        if let formatter = appDelegate.dateFormatter {
            dateFormatter = formatter
        }
        else {
            appDelegate.dateFormatter = DateFormatter()
            dateFormatter = appDelegate.dateFormatter!
        }
        
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        print("date")
        return date
    }
}
