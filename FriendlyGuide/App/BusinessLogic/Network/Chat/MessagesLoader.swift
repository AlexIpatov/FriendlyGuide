//
//  MessagesLoader.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation

typealias GetMessagesResponse = (messages: [Message], totalNumberOfMessages: Int)

protocol MessagesLoader {
    func messages(for dialog: Dialog,
                  skip: Int,
                  limit: Int,
                  extendedRequest extendedParameters: [String: String]?,
                  completion: @escaping (Result<GetMessagesResponse, Error>) -> Void)
}
