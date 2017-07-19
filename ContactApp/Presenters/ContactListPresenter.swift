//
//  ContactListPresenter.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

class ContactListPresenter {
    private let coreDataManager:CoreDataManager
    private var contactView: ContactListViewProtocol?
    
    init(coreDataManager:CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func attachView(view:ContactListViewProtocol) {
        contactView = view
        contactView?.setupViewLayout()
    }
    
    func detachView() {
        contactView = nil
    }
    
    func loadContacts() {
        print("loadcontacts")
        self.contactView?.showLoadingIndicator()
        let syncManager = ContactSynchronizer(persistentContainer: coreDataManager.persistentContainer)
        syncManager.sync {
            print("syncontacts done")
            let contacts = self.coreDataManager.allContacts()
            self.contactView?.hideLoadingIndicator()
            if contacts.count == 0 {
                self.contactView?.setEmptyUsers()
            }
            else {
                self.contactView?.loadContacts(contacts: contacts)
            }
        }
    }
    
    func loadDetailContact(contactId:String) {
        if let contact = coreDataManager.contactWithId(contactId) {
            
        }
    }
}
