//
//  ChatViewModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation
import Quickblox

protocol ChatViewModelRepresentable {
    var delegate: ChatViewModelDelegate? { get set }
    var currentUser: User { get }
    var dialogName: String { get }
    
    func message(at index: Int) -> Message
    func numberOfMessages() -> Int
    
    func send(message: Message, completion: @escaping () -> Void)
    func joinDialog(completion: @escaping (Error?) -> Void)
}

final class ChatViewModel {

    private var messages = [Message]()
    
    private var totalNumberOfMessages: Int = -1
    private let messagesRequestLimit: Int = 35
    private var isRequestAlreadySended: Bool = false
    
    private let dialog: Dialog
    private let user: User
    
    private let getMessagesRequestFactory: MessagesLoader
    private let getUserRequestFactory: GetUserRequestFactory
    private let sendMessagesRequestFactory: MessagesSender
    private let joinDialogRequestFactory: DialogActivator
    
    weak var delegate: ChatViewModelDelegate?
    
    init(dialog: Dialog, user: User,
         getMessagesRequestFactory: MessagesLoader,
         getUserRequestFactory: GetUserRequestFactory,
         sendMessagesRequestFactory: MessagesSender,
         joinDialogRequestFactory: DialogActivator) {
        self.getMessagesRequestFactory = getMessagesRequestFactory
        self.getUserRequestFactory = getUserRequestFactory
        self.sendMessagesRequestFactory = sendMessagesRequestFactory
        self.joinDialogRequestFactory = joinDialogRequestFactory
        self.dialog = dialog
        self.user = user
    }
}

extension ChatViewModel: ChatViewModelRepresentable {
    var currentUser: User {
        user
    }
    
    var dialogName: String {
        dialog.dialogName
    }
    
    func message(at index: Int) -> Message {
        if index.distance(to: messages.count) < 3 &&
            messages.count != totalNumberOfMessages { getMoreMessages() }
        return messages[index]
    }
    
    func numberOfMessages() -> Int {
        return messages.count
    }
    
    func getMoreMessages() {
        if !isRequestAlreadySended {
            isRequestAlreadySended = true
            
            getMessagesRequestFactory.messages(for: dialog,
                                               skip: messages.count,
                                               limit: messagesRequestLimit,
                                               extendedRequest: nil) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let self = self else {
                        return
                    }
                    
                    self.totalNumberOfMessages = response.totalNumberOfMessages
                    let numberOfDialogsBeforUpdate = self.messages.count
                    
                    let messagesGroup = DispatchGroup()
                    response.messages.forEach { [weak self] message in
                        guard let self = self else { return }
                        messagesGroup.enter()
                        
                        self.getUserRequestFactory.loadUser(message.messageSender.userID) { [weak self] user in
                            if let user = user {
                                let message = Message(sentDate: message.sentDate,
                                                      messageSender: user,
                                                      messageText: message.messageText,
                                                      messageId: message.messageId,
                                                      dialogId: message.dialogId)
                                
                                self?.messages.append((message))
                            }
                            
                            messagesGroup.leave()
                        }
                    }
                    
                    messagesGroup.notify(queue: .main) { [weak self] in
                        guard let self = self else { return }
                        
                        let indexes = Array(numberOfDialogsBeforUpdate..<self.messages.count)
                        self.delegate?.didFinishFetchData(at: indexes)
                        self.isRequestAlreadySended = false
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
    
    func send(message: Message, completion: @escaping () -> Void) {
        sendMessagesRequestFactory.send(message, in: dialog) { [weak self] error in
            if let error = error { self?.delegate?.present(error: error) }
            completion()
        }
    }

    func joinDialog(completion: @escaping (Error?) -> Void) {
        //joinDialogRequestFactory.join(to: dialog) { completion($0) }
    }
}
