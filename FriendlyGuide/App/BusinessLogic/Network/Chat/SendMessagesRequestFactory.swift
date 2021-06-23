//
//  SendMessagesRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation

protocol SendMessagesRequestFactory {
    associatedtype M where M: Message
    associatedtype D where D: Dialog
    
    func send(_ message: M,
              in dialog: D,
              completion: @escaping (Error?) -> Void)
}
