//
//  RegisterModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import Foundation

protocol RegisterModelRepresentable: AnyObject {
    var name: String { get }
    var login: String { get }
    var password: String { get }
    var confirmPassword: String { get }

    func tryToUpdate(name: String) -> Result<Bool, Error>
    func tryToUpdate(login: String) -> Result<Bool, Error>
    func tryToUpdate(password: String) -> Result<Bool, Error>
    func tryToUpdate(confirmPassword: String) -> Result<Bool, Error>
}


final class RegisterModel {
    enum RegisterError: LocalizedError {
        case pasworsdMismatch
        
        var errorDescription: String? {
            switch self {
            case .pasworsdMismatch:
                return "Пароль должны совпадать"
            }
        }
    }
    
    private(set) var name: String = ""
    private(set) var login: String = ""
    private(set) var password: String = ""
    private(set) var confirmPassword: String = ""

    private let passwordValidator: PasswordValidator
    private let loginValidator: LoginValidator
    
    init(passwordValidator: PasswordValidator,
         loginValidator: LoginValidator) {
        self.passwordValidator = passwordValidator
        self.loginValidator = loginValidator
    }
}

extension RegisterModel: RegisterModelRepresentable {
    func tryToUpdate(login: String) -> Result<Bool, Error> {
        do {
            try loginValidator.validate(login: login)
            self.login = login
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func tryToUpdate(password: String) -> Result<Bool, Error> {
        do {
            try passwordValidator.validate(password: password)
            self.password = password
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    func tryToUpdate(confirmPassword: String) -> Result<Bool, Error> {
        if password == confirmPassword {
            self.confirmPassword = confirmPassword
            return .success(true)
        } else { return .failure(RegisterError.pasworsdMismatch) }
    }
    
    func tryToUpdate(name: String) -> Result<Bool, Error> {
        self.name = name
        return .success(true)
    }
}

