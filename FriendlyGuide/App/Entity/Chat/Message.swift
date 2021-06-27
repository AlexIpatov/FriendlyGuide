//
//  Message.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 19.06.2021.
//

import Foundation
import MessageKit

struct Message {
    var sentDate: Date
    var messageSender: User
    
    var messageText: String
    var messageId: String
    
    var dialogId: String
}

extension Message: MessageType {
     var sender: SenderType {
        messageSender
    }
    
    var kind: MessageKind {
        .text(messageText)
    }
}
