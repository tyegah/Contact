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
    
    func configureWithJSONDictionary(_ jsonDict:[String:Any]) {
        id = jsonDict["id"] as? Int32 ?? 0
        firstName = jsonDict["first_name"] as? String
        lastName = jsonDict["last_name"] as? String
        isFavorite = (jsonDict["favorite"] as? NSNumber)?.boolValue ?? false
        url = jsonDict["url"] as? String
        profilePic = jsonDict["profile_pic"] as? String
        phoneNumber = jsonDict["phone_number"] as? String
        email = jsonDict["email"] as? String
        createdAt = (jsonDict["created_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
        updatedAt = (jsonDict["updated_at"] as? String)?.convertToDate("yyyy-MM-ddThh:mm:ssZ") as NSDate?
    }
}
