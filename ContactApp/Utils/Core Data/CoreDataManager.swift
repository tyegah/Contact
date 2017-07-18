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
    
    func contactWithId(_ id:String) -> Contact? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
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
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
