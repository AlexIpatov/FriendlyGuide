//
//  Authorizable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol Authorizable {
    var login: String { get set }

    var password: String { get set }
    var oldPassword: String? { get set }
}
