//
//  ChatConnectable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 24.05.2021.
//

import Foundation
import Quickblox


typealias ChatUser = (ChatConnectable & Authorizable)

protocol ChatConnectable {
    var userID: UInt { get set }
    var fullName: String { get set }
}


protocol Authorizable {
    var login: String { get set }

    var password: String { get set }
    var oldPassword: String { get set }
}

protocol WithEmailAuthorizable: Authorizable {
    var email: String { get set }
}

protocol WithPhoneAuthorizable: Authorizable {
    var phone: String { get set }
}
