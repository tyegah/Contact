//
//  CoreDataManager.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/17/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer:NSPersistentContainer
    
    init(persistentContainer:NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func allContacts() -> [Contact] {
        do {
            let contacts = try self.persistentContainer.viewContext.fetch(NSFetchRequest(entityName: "Contact")) as! [Contact]
            return contacts
        }
        catch {
            print("Error fecthing contacts")
        }
        
        return []
    }
    
    func contactWithId(_ id:Int) -> Contact? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
            let contacts = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Contact]
            if let count = contacts?.count, count > 0 {
                return contacts?[0]
            }
        }
        catch {
            print("failed fetching contact with id \(id)")
        }
        
        return nil
    }
    
    // contacts that aren't available on server
    func unsyncedContacts() -> [Contact] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = 0")
        do {
            let unsyncedContacts = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Contact]
            return unsyncedContacts ?? []
        }
        catch {
            print("failed fetching unsynced contacts")
        }
        
        return []
    }
    
    // contacts that are updated locally but not on server
    func contactsThatChangedSince(_ timestamp: TimeInterval) -> [Contact] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "updatedAt > %f", timestamp)
        do {
            let updatedContacts = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Contact]
            return updatedContacts ?? []
        }
        catch {
            print("failed fetching unsynced contacts")
        }
        
        return []
    }
    
    func syncedUpdateContactsChangedSince(_ timestamp: TimeInterval) -> [Contact] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "updatedAt > %f AND id != 0", timestamp)
        do {
            let updatedContacts = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Contact]
            return updatedContacts ?? []
        }
        catch {
            print("failed fetching synced updated contacts")
        }
        
        return []
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func lastSyncAttempt() -> TimeInterval? {
        return UserDefaults.standard.double(forKey: "lastSyncAttempt")
    }
}
