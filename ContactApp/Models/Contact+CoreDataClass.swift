//
//  Contact+CoreDataClass.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation
import CoreData


public class Contact: NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Contact", in: context)!
        self.init(entity: entityDescription, insertInto: context)
    }
    
    func configureWithJSONDictionary(_ jsonDict:[String:Any], isUpdate:Bool = false) {
        if !isUpdate {
            uuid = NSUUID().uuidString
        }
        
        id = (jsonDict["id"] as? NSNumber)?.int32Value ?? 0
        firstName = jsonDict["first_name"] as? String
        lastName = jsonDict["last_name"] as? String
        isFavorite = (jsonDict["favorite"] as? NSNumber)?.boolValue ?? false
        url = jsonDict["url"] as? String
        profilePic = jsonDict["profile_pic"] as? String
        phoneNumber = jsonDict["phone_number"] as? String
        email = jsonDict["email"] as? String
        if let createdDate = (jsonDict["created_at"] as? String)?.convertServerTimeToDate() {
            createdAt = Int64(createdDate.timeIntervalSince1970)
        }
        else {
            createdAt = 0
        }
        
        if let updatedDate = (jsonDict["updated_at"] as? String)?.convertServerTimeToDate() {
            updatedAt = Int64(updatedDate.timeIntervalSince1970)
        }
        else {
            updatedAt = 0
        }
        
        print("createdat \(createdAt)")
    }
    
    class func toJSONDictionary(contact:Contact?) -> [String:Any]? {
        if let c = contact {
            var keys:[String] = c.entity.attributesByName.keys.map { $0 }
            keys = keys.filter { $0 != "uuid"}
            print("keys \(keys)")
            return self.dictionaryWithValues(forKeys: keys)
        }
        return nil
    }
}

