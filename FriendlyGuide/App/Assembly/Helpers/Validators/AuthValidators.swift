//
//  AuthValidators.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import Foundation

class Validators {
    static func isFilledLogIn(login: String?, password: String?) -> Bool {
        guard let password = password,
              let login = login,
              password != "",
              login != "" else {
            return false
        }
        return true
    }
    static func isFilledRegister(userName: String?,
                                 fullName: String?,
                                 password: String?,
                                 confirmPassword: String?) -> Bool {
        guard let userName = userName,
              let password = password,
              let confirmPassword = confirmPassword,
              userName != "",
              password != "",
              confirmPassword != ""
        else {
            return false
        }
        return true
    }
    static func isSimplePassword(_ password: String?) -> Bool {
        let passwordregex = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=]).{8,}$"
        return check(text: password, regEx: passwordregex)
    }
    private static func check(text: String?, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}

