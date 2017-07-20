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
    private let syncManager:ContactSynchronizer
    
    init(coreDataManager:CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.syncManager = ContactSynchronizer(persistentContainer: self.coreDataManager.persistentContainer)
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
    
    func loadDetailContact(_ id:Int) {
        if let contact = coreDataManager.contactWithId(id) {
            self.contactView?.showLoadingIndicator()
            if contact.createdAt == 0 {
                // contact is not synced
                // fetch detail
                syncManager.syncDownloadSingleContactWithId(id, completion: { (c) in
                    self.contactView?.hideLoadingIndicator()
                    self.contactView?.showDetailContact(contact: c)
                })
            }
            else {
                self.contactView?.hideLoadingIndicator()
                self.contactView?.showDetailContact(contact: contact)
            }
        }
        else {
            // Show Error here
        }
    }
}
