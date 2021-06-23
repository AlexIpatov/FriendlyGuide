//
//  Message.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation


protocol Message {
    var messageText: String { get set }
    var sentDate: Date { get set }
    var senderId: Int { get set }
}
