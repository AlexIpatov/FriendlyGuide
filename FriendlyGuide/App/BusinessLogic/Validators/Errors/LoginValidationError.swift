//
//  LoginValidationError.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import Foundation

enum LoginValidationError: Error, LocalizedError {
    case mustBeEmail
    
    var errorDescription: String? {
        switch self {
        case .mustBeEmail:
            return "Это не емеил, батенька"
        }
    }
}
