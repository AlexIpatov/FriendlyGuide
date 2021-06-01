//
//  LogInModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import Foundation

protocol LogInModelRepresentable {
    var login: String { get }
    var password: String { get }

    func tryToUpdate(login: String) -> Error?
    func tryToUpdate(password: String) -> Error?
}

final class LogInModel {
   
    var login: String = ""
    var password: String = ""
    
    private let passwordValidator: PasswordValidator
    private let loginValidator: LoginValidator
    
    init(passwordValidator: PasswordValidator,
         loginValidator: LoginValidator) {
        self.passwordValidator = passwordValidator
        self.loginValidator = loginValidator
    }
}

extension LogInModel: LogInModelRepresentable {
    func tryToUpdate(login: String) -> Error? {
        do {
            try loginValidator.validate(login: login)
            self.login = login
            return nil
        } catch {
            return error
        }
    }

    func tryToUpdate(password: String) -> Error? {
        do {
            try passwordValidator.validate(password: password)
            self.password = password
            return nil
        } catch {
            return error
        }
    }
}
