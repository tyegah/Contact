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
        self.contactView?.showLoadingIndicator()
    }
}
