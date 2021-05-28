//
//  User.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

struct User: ChatAuthorizable
             & ChatConnectable {

    var userID: UInt    
    var fullName: String
    
    var login: String

    var password: String
    var oldPassword: String
}
