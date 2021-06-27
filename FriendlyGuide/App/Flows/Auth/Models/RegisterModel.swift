//
//  RegisterModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import Foundation

protocol RegisterModelRepresentable: AnyObject {
    var delegate: RegisterModelDelegate? { get set }
    
    var name: String { get }
    var login: String { get }
    var password: String { get }
    var confirmPassword: String { get }

    func tryToUpdate(name: String) -> Error?
    func tryToUpdate(login: String) -> Error?
    func tryToUpdate(password: String) -> Error?
    func tryToUpdate(confirmPassword: String) -> Error?
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
    
    private(set) var name: String = "" {
        didSet { sendNotificationsIfNeed() }
    }
    private(set) var login: String = "" {
        didSet { sendNotificationsIfNeed() }
    }
    private(set) var password: String = "" {
        didSet { sendNotificationsIfNeed() }
    }
    private(set) var confirmPassword: String = "" {
        didSet { sendNotificationsIfNeed() }
    }

    private let passwordValidator: PasswordValidator
    private let loginValidator: LoginValidator
    
    weak var delegate: RegisterModelDelegate?
    init(passwordValidator: PasswordValidator,
         loginValidator: LoginValidator) {
        self.passwordValidator = passwordValidator
        self.loginValidator = loginValidator
    }
    
    private func sendNotificationsIfNeed() {
        if !login.isEmpty &&
            !name.isEmpty &&
            !password.isEmpty &&
            !confirmPassword.isEmpty {
            delegate?.prepareToShowSignInButton()
        }
        
        if !password.isEmpty {
            delegate?.prepareToShowConfirmPasswordTextField()
        }
    }
}

extension RegisterModel: RegisterModelRepresentable {
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
    
    func tryToUpdate(confirmPassword: String) -> Error? {
        if password == confirmPassword {
            self.confirmPassword = confirmPassword
            return nil
        } else { return RegisterError.pasworsdMismatch }
    }
    
    func tryToUpdate(name: String) -> Error? {
        self.name = name
        return nil
    }
}
