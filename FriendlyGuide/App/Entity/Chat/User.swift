//
//  User.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 19.06.2021.
//

import Foundation
import MessageKit

struct User {
    var userID: UInt
    var userName: String? = nil
    var userLogin: String? = nil
    var userPassword: String? = nil
}

extension User: SenderType {
    var senderId: String {
        "\(userID)"
    }
    
    var displayName: String {
        userName ?? ""
    }
}


