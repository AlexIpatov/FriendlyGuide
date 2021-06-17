//
//  ReadMessagesRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 15.06.2021.
//

import Foundation

protocol ReadMessagesRequestFactory {
    associatedtype M where M: Message
    associatedtype D where D: Dialog
    
    func read(_ messages: [M],
              dialog: D,
              completion: @escaping (_ error: Error) -> Void)
}
