//
//  ContactDetailViewProtocol.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

protocol ContactDetailViewProtocol:ContactBaseProtocol {
    func reloadView(contact:Contact?)
    // actions
    func editContact()
    func makeCall()
    func sendMessage()
    func sendEmail()
    func makeFavorite()
}
