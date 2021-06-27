//
//  LoginValidator.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import Foundation

protocol LoginValidator {
    func validate(login: String) throws
}
