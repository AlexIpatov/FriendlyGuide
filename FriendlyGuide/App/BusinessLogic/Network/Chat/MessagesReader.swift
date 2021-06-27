//
//  MessagesReader.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 15.06.2021.
//

import Foundation

protocol MessagesReader {
    func read(_ messages: [Message],
              dialog: Dialog,
              completion: @escaping (_ error: Error) -> Void)
}
