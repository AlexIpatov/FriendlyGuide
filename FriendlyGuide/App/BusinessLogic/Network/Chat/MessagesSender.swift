//
//  MessagesSender.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation

protocol MessagesSender {
    func send(_ message: Message,
              in dialog: Dialog,
              completion: @escaping (Error?) -> Void)
    
    func send(_ messages: [Message],
              in dialog: Dialog,
              completion: @escaping (Error?) -> Void)
}
