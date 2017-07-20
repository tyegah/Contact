//
//  APIManager.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/17/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

typealias ContactServerID = Int
typealias FetchContactsCompletion = ([[String:Any]]?) -> Void
typealias FetchContactDetailCompletion = ([String:Any]?) -> Void
typealias AddNewContactCompletion = ([String:Any]?) -> Void
typealias UpdateContactCompletion = ([String:Any]?) -> Void
typealias DeleteContactCompletion = (Bool) -> Void
class APIManager {
    static let shared = APIManager()
    private let networking:Networking
    let reachability = Reachability()!
    init() {
        networking = Networking(baseURL: Config.baseURL)
        do {
            try reachability.startNotifier()
        }
        catch {
            print("failed to start notifier")
        }
    }
    
    func fetchContacts(completion: @escaping FetchContactsCompletion) {
        if reachability.isReachable {
            networking.get(pathURL: "contacts.json") { (response) in
                print(response.responseJSON ?? ["":""])
                if let json = response.responseJSON as? [[String:Any]] {
                    completion(json)
                    return
                }
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func fetchContactDetailWithId(_ id:Int, completion: @escaping FetchContactDetailCompletion) {
        if reachability.isReachable {
            networking.get(pathURL: "contacts/\(id).json", completion: { (response) in
//                print("Contact Detail response \(String(describing: response.responseJSON))")
                if let json = response.responseJSON as? [String:Any] {
                    completion(json)
                    return
                }
                
                completion(nil)
            })
        }
        else {
            completion(nil)
        }
    }
    
    func addNewContact(_ contact:Contact, completion: @escaping AddNewContactCompletion) {
        if reachability.isReachable {
            if let contactJSON = Contact.toJSONDictionary(contact: contact) as? [String:String]{
                networking.post(pathURL: "contacts.json", parameters: contactJSON, completion: { (response) in
                    if let json = response.responseJSON as? [String:Any] {
                        completion(json)
                        return
                    }
                    else {
                        completion(nil)
                    }
                })
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    func updateContact(_ contact:Contact, completion: @escaping UpdateContactCompletion) {
        if reachability.isReachable {
            if let dict = Contact.toJSONDictionary(contact: contact) {
                networking.put(pathURL: "contacts/\(contact.id).json", parameters: dict, completion: { (response) in
                    if let json = response.responseJSON as? [String:Any] {
                        completion(json)
                        return
                    }
                    else {
                        completion(nil)
                    }
                })
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
    
    
    func createAddContactRequest(_ contact: Contact) -> ContactManagerAddRequest {
        return ContactManagerAddRequest(contact: contact)
    }
    
    func createUpdateContactRequest(_ contact:Contact) -> ContactManagerUpdateRequest {
        return ContactManagerUpdateRequest(contact: contact)
    }
}

class ContactManagerDetailRequest {
    var id:Int
    var networking:Networking
    let reachability = Reachability()!
    required init(id:Int) {
        self.id = id
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performFetch(with completion:@escaping FetchContactDetailCompletion) {
        if reachability.isReachable {
            networking.get(pathURL: "contacts/\(self.id).json", completion: { (response) in
                if let json = response.responseJSON as? [String:Any] {
                    completion(json)
                    return
                }
                else {
                    completion(nil)
                }
            })
        }
        else {
            completion(nil)
        }
    }
}

class ContactManagerAddRequest {
    var contact:Contact
    var networking:Networking
    let reachability = Reachability()!
    required init(contact:Contact) {
        self.contact = contact
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performAdd(with completion:@escaping AddNewContactCompletion) {
        if reachability.isReachable {
            if let contactJSON = Contact.toJSONDictionary(contact: contact) as? [String:String]{
                networking.post(pathURL: "contacts.json", parameters: contactJSON, completion: { (response) in
                    if let json = response.responseJSON as? [String:Any] {
                        completion(json)
                        return
                    }
                    else {
                        completion(nil)
                    }
                })
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
}

class ContactManagerUpdateRequest {
    var contact:Contact
    var networking:Networking
    let reachability = Reachability()!
    required init(contact:Contact) {
        self.contact = contact
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performUpdate(with completion:@escaping UpdateContactCompletion) {
        if reachability.isReachable {
            if let dict = Contact.toJSONDictionary(contact: contact) {
                networking.put(pathURL: "contacts/\(contact.id).json", parameters: dict, completion: { (response) in
                    if let json = response.responseJSON as? [String:Any] {
                        completion(json)
                        return
                    }
                    else {
                        completion(nil)
                    }
                })
            }
            else {
                completion(nil)
            }
        }
        else {
            completion(nil)
        }
    }
}
