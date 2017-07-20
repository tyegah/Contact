//
//  ContactDetailViewProtocol.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

protocol ContactDetailViewProtocol:ContactBaseProtocol {
//    func loadContact(contacts:Contact?)
    func reloadView()
    // actions
    func editContact()
}
