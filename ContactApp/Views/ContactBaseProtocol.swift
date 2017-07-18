//
//  ContactBaseProtocol.swift
//  ContactApp
//
//  Created by Tity Septiani on 7/18/17.
//  Copyright © 2017 Tity Septiani. All rights reserved.
//

import Foundation

protocol ContactBaseProtocol:NSObjectProtocol {
    func setupViewLayout()
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
