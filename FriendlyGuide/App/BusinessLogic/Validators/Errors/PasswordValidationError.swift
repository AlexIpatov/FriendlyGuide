//
//  PasswordValidationError.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import Foundation

enum PasswordValidationError: Error, LocalizedError {
    case tooShortPassword
    case mustHaveOneCapitalLetter
    case mustHaveOneLowercaseLetter
    
    
    var errorDescription: String? {
        switch self {
        case .tooShortPassword:
            return "Пароль должен содержать не меньше 8 символов"
        case .mustHaveOneCapitalLetter:
            return "Пароль должен содержать как минимум одну заглавную букву"
        case .mustHaveOneLowercaseLetter:
            return "Пароль должен содержать как минимкм одну прописную букву"
        }
    }
}
