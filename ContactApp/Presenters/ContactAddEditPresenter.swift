//
//  ContactAddEditPresenter.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

class ContactAddEditPresenter {
    private let coreDataManager:CoreDataManager
    private var contactView: ContactAddEditViewProtocol?
    private let syncManager:ContactSynchronizer
    
    init(coreDataManager:CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.syncManager = ContactSynchronizer(persistentContainer: self.coreDataManager.persistentContainer)
    }
    
    func attachView(view:ContactAddEditViewProtocol) {
        contactView = view
        contactView?.setupViewLayout()
    }
    
    func detachView() {
        contactView = nil
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            self.contactView?.reloadView()
        }
    }
    
    func saveContact(id:Int, firstName:String?, lastName:String?, phoneNumber:String?, email:String?) {
        if id == 0 {
            coreDataManager.addNewContact(firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        }
        else {
            coreDataManager.updateContactWithId(id, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, email: email)
        }
        
        syncManager.uploadSync {
            
        }
        
        self.contactView?.popView()
    }
}
