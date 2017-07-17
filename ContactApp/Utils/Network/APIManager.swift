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
    private let reachability = Reachability()!
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
                print(response.responseJSON)
                if let json = response.responseJSON as? [[String:Any]] {
                    completion(json)
                }
            }
        }
        completion(nil)
    }
    
    func fetchContactDetailWithId(_ id:Int, completion: @escaping FetchContactDetailCompletion) {
        if reachability.isReachable {
            networking.get(pathURL: "contacts/\(id).json", completion: { (response) in
                print("Contact Detail response \(response.responseJSON)")
                if let json = response.responseJSON as? [String:Any] {
                    completion(json)
                }
            })
        }
        completion(nil)
    }
    
}


class ContactManagerAddRequest {
    var contact:Contact
    var networking:Networking
    required init(contact:Contact) {
        self.contact = contact
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performAdd(with completion:@escaping AddNewContactCompletion) {
        networking.post(pathURL: "contacts.json", parameters: ["":""]) { (response) in
            
        }
    }
}

class ContactManagerUpdateRequest {
    var contact:Contact
    var networking:Networking
    required init(contact:Contact) {
        self.contact = contact
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performUpdate(with completion:@escaping UpdateContactCompletion) {
        networking.put(pathURL: "contacts\(contact.id).json", parameters: ["":""]) { (response) in
            
        }
    }
}
