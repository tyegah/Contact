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
    let context: NSManagedObjectContext
    
    init(context:NSManagedObjectContext) {
        self.context = context
    }
    
    func allContacts() -> [Contact] {
        do {
            let contacts = try self.context.fetch(NSFetchRequest(entityName: "Contact")) as! [Contact]
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
            let contacts = try context.fetch(fetchRequest) as? [Contact]
            if let count = contacts?.count, count > 0 {
                return contacts?[0]
            }
        }
        catch {
            print("failed fetching contact with id \(id)")
        }
        
        return nil
    }
}
