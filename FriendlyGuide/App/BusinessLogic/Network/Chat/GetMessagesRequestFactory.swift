//
//  GetMessagesRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation

typealias MessagesCompletion = (_ messages: [Message],
                                _ totalNumberOfMessages: Int) -> Void

typealias MessagesErrorHandler = (_ error: Error) -> Void

protocol GetMessagesRequestFactory {
    func messages(for dialog: Dialog,
                  skip: Int,
                  limit: Int,
                  extendedRequest extendedParameters: [String: String]?,
                  successCompletion: MessagesCompletion?,
                  errorHandler: MessagesErrorHandler?)
}
