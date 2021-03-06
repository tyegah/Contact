//
//  ContactAddEditProtocol.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

protocol ContactAddEditViewProtocol:ContactBaseProtocol {
    // actions
    func popView()
    func reloadView()
    func takePicture()
    func saveContact()
}
