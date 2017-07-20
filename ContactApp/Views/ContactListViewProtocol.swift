//
//  ContactListViewProtocol.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

protocol ContactListViewProtocol:ContactBaseProtocol {
    func loadContacts(contacts:[Contact])
    func setEmptyUsers()
    
    // actions
    func handleRefresh()
    func showGroups()
    func addContact()
    func showDetailContact(contact:Contact?)
}
