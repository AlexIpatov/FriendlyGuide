//
//  QBChatDialog + Dialog.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import Foundation
import  Quickblox

extension QBChatDialog: Dialog {
    var dialogLastMessageText: String {
        get { self.lastMessageText ?? "" }
        set { self.lastMessageText = newValue }
    }
    
    var dialogLastMessageUserId: UInt {
        get { self.lastMessageUserID }
        set { self.lastMessageUserID = newValue }
    }
    
    var dialogName: String {
        get { self.name ?? "" }
        set { self.name = newValue }
    }
    
    var dialogId: String {
        get { self.id ?? "" }
    }
    
    var dialogImageURL: URL? {
        get { URL(string: self.photo ?? "") }
        set { self.photo = newValue?.absoluteString }
    }
}

