//
//  PasswordKeychainRequest.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 02.06.2021.
//

import Foundation

struct PasswordKeychainRequest: KeychainRequest {
    var accountName: String {
        "obryga.corp.FriendlyGuide.user_data_password"
    }
    
    var key: String {
        "password"
    }
}
