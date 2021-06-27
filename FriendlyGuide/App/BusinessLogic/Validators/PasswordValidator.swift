//
//  PasswordValidator.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import Foundation

protocol PasswordValidator {
    func validate(password: String) throws
}
