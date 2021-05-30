//
//  Dialog.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation
import Quickblox

struct Dialog {
//
//    var id: String
//
//    var createdAt: Date
//    var updatedAt: Date
//
//    var name: String
//    var photo: String
//
//    var lastMessageText: String
//    var lastMessageDate: Date
//    var lastMessageUserID: Int
//    var lastMessageID: Int
//
//    var unreadMessagesCount: Int
//
//    var occupantIDs: [Int]
//    var dilogOwnerId: Int
//
//    var data: [String: Any]
}

// MARK: - init with QBChatDialog

extension Dialog {
    init(dialog: QBChatDialog) {
        
    }
}

// MARK: - Empty Dialog

extension Dialog {
    static var empty: Dialog {
        Dialog()
    }
}
