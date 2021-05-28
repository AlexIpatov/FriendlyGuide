//
//  ChatConnectable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatConnectable {
    var userID: UInt { get set }
    var fullName: String { get set }
}
