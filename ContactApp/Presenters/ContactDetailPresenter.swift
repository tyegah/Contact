//
//  ContactDetailPresenter.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

class ContactDetailPresenter {
    private let coreDataManager:CoreDataManager
    private var contactView: ContactDetailViewProtocol?
    private let syncManager:ContactSynchronizer
    
    init(coreDataManager:CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.syncManager = ContactSynchronizer(persistentContainer: self.coreDataManager.persistentContainer)
    }
    
    func attachView(view:ContactDetailViewProtocol) {
        contactView = view
        contactView?.setupViewLayout()
    }
    
    func detachView() {
        contactView = nil
    }
    
    func reloadView() {
        self.contactView?.reloadView()
    }
    
    func makeFavorite(contact:Contact?) {
        // 
    }
}
