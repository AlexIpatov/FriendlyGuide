//
//  AuthError.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidPassword
    case passwordsNotMatched
    case unknownError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return "Вы заполнили не все поля"
        case .passwordsNotMatched:
            return "Пароли не совпадают"
        case .unknownError:
            return "Неизвестная ошибка"
        case .invalidPassword:
            return"""
Your password must contain:
One or more digit
One or more lower case letter
One or more uppercase letter
One or more special symbol
Eight or more characters
"""
        }
    }
}

