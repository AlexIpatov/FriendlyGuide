//
//  LoginKeychainRequest.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 02.06.2021.
//

import Foundation

struct LoginKeychainRequest: KeychainRequest {
    var accountName: String {
        "com.FriendlyGuide.user_login"
    }
    
    var key: String {
        "login"
    }
}
