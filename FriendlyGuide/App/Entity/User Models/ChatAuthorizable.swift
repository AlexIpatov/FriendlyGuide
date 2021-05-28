//
//  ChatAuthorizable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatAuthorizable {
    var login: String { get set }

    var password: String { get set }
    var oldPassword: String { get set }
}
