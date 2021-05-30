//
//  ChatManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol ChatManager: ChatDialogsManager,
                      ChatMessagesManager,
                      ChatUsersManager,
                      AuthenticatorManager {
    static func initialise()
    static var instance: Self { get }
}
