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
    init() {
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func fetchContacts(completion: @escaping FetchContactsCompletion) {
        if ReachabilityManager.shared.isNetworkAvailable {
            networking.get(pathURL: "contacts.json") { (response) in
//                print(response.responseJSON ?? ["":""])
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
        if ReachabilityManager.shared.isNetworkAvailable {
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
    
//    func addNewContact(_ contact:Contact, completion: @escaping AddNewContactCompletion) {
//        if ReachabilityManager.shared.isNetworkAvailable {
//            if let contactJSON = Contact.toJSONDictionary(contact: contact) as? [String:String]{
//                networking.post(pathURL: "contacts.json", parameters: contactJSON, completion: { (response) in
//                    if let json = response.responseJSON as? [String:Any] {
//                        completion(json)
//                        return
//                    }
//                    else {
//                        completion(nil)
//                    }
//                })
//            }
//            else {
//                completion(nil)
//            }
//        }
//        else {
//            completion(nil)
//        }
//    }
//    
//    func updateContact(_ contact:Contact, completion: @escaping UpdateContactCompletion) {
//        if ReachabilityManager.shared.isNetworkAvailable {
//            if let dict = Contact.toJSONDictionary(contact: contact) {
//                networking.put(pathURL: "contacts/\(contact.id).json", parameters: dict, completion: { (response) in
//                    if let json = response.responseJSON as? [String:Any] {
//                        completion(json)
//                        return
//                    }
//                    else {
//                        completion(nil)
//                    }
//                })
//            }
//            else {
//                completion(nil)
//            }
//        }
//        else {
//            completion(nil)
//        }
//    }
    
    
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
    required init(id:Int) {
        self.id = id
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performFetch(with completion:@escaping FetchContactDetailCompletion) {
        if ReachabilityManager.shared.isNetworkAvailable {
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
    required init(contact:Contact) {
        self.contact = contact
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performAdd(with completion:@escaping AddNewContactCompletion) {
        if ReachabilityManager.shared.isNetworkAvailable {
            if let contactJSON = Contact.toJSONDictionary(contact: contact){
                print("JSON \(contactJSON)")
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
    required init(contact:Contact) {
        self.contact = contact
        networking = Networking(baseURL: Config.baseURL)
    }
    
    func performUpdate(with completion:@escaping UpdateContactCompletion) {
        if ReachabilityManager.shared.isNetworkAvailable {
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

class ReachabilityManager: NSObject {
    
    static let shared = ReachabilityManager()  // 2. Shared instance
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    // 5. Reachibility instance for Network status monitoring
    let reachability = Reachability()!
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            KSToastView.ks_showToast("You are offline")
        case .reachableViaWiFi:
            debugPrint("Network reachable through WiFi")
        case .reachableViaWWAN:
            debugPrint("Network reachable through Cellular Data")
        }
    }
    
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
}
