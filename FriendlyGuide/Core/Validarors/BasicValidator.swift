//
//  BasicValidator.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import Foundation

class BasicValidator {
    private enum PasswordValidator: String {
        case atLeast8Characters = #"(?=.{8,})"#
        case atLeastOneCapitalLetter = #"(?=.*[A-Z])"#
        case atLeastOneLowercaseLetter = #"(?=.*[a-z])"#
        case atLeastOneDigit = #"(?=.*\d)"#
        case atLeastOneSpecialCharacter = #"(?=.*[ !$%&?._-])"#
    }
    
    private enum LoginValidator: String {
        case email = #"^\S+@\S+\.\S+$"#
    }
    
    private func isContain(_ range: Range<String.Index>?) -> Bool {
        range != nil
    }
}

extension BasicValidator: PasswordValidator {
    func validate(password: String) throws {
        if !isContain(password.range(of: PasswordValidator.atLeast8Characters.rawValue,
                                    options: .regularExpression)) {
            throw PasswordValidationError.tooShortPassword
        }
        
        if !isContain(password.range(of: PasswordValidator.atLeastOneCapitalLetter.rawValue,
                                    options: .regularExpression)) {
            throw PasswordValidationError.tooShortPassword
        }
        
        if !isContain(password.range(of: PasswordValidator.atLeastOneLowercaseLetter.rawValue,
                                    options: .regularExpression)) {
            throw PasswordValidationError.tooShortPassword
        }
        
//        if !isContain(password.range(of: PasswordValidator.atLeastOneDigit.rawValue,
//                                    options: .regularExpression)) {
//            throw Validation.PasswordValidationError.tooShortPassword
//        }
//
//        if !isContain(password.range(of: PasswordValidator.atLeastOneSpecialCharacter.rawValue,
//                                    options: .regularExpression)) {
//            throw Validation.PasswordValidationError.tooShortPassword
//        }
    }
}

extension BasicValidator: LoginValidator {
    func validate(login: String) throws{
        if !isContain(login.range(of: LoginValidator.email.rawValue,
                                    options: .regularExpression)) {
            throw LoginValidationError.mustBeEmail
        }
    }
}
