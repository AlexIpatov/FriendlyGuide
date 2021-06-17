//
//  QBChatMessage + Message.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation
import Quickblox

extension QBChatMessage: Message {
    var senderId: Int {
        get { Int(self.senderID) }
        set { self.senderID = UInt(newValue) }
    }
    
    var messageText: String {
        get { self.text ?? "" }
        set { self.text = newValue }
    }
    
    var sentDate: Date {
        get { self.dateSent ?? Date() }
        set { self.dateSent = newValue }
    }
}
