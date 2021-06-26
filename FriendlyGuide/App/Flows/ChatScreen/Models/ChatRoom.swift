//
//  ChatRoom.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.06.2021.
//

import Foundation

protocol ChatRoomProtocol: AnyObject {
    var currentUser: User { get }
    var currendDialog: Dialog { get }
    
    func join(completion: @escaping (Error?) -> Void)
    func add<Observer: ChatRoomObserver>(observer: Observer)
    
    func send(_ message: Message, completion: @escaping (Error?) -> Void)
    func read(_ message: Message, completion: @escaping (Error?) -> Void)
    func load(limit: Int, skip: Int, completion: @escaping (Result<GetMessagesResponse, Error>) -> Void)
}

protocol ChatRoomDelegate: AnyObject {
    func receive(_ message: Message)
}

protocol ChatRoomObserver: AnyObject {
    func didRecieve(_ message: Message)
}

final class ChatRoom {
    
    private var delegates = NSPointerArray.weakObjects()
    
    let currendDialog: Dialog
    var currentUser: User {
        if let currentUser = currnetUserLoader.currentUser { return currentUser }
        else { fatalError("[ChatRoom]: Can't defin current user.") }
    }
    
    private let messagesSender: MessagesSender
    private let messagesReader: MessagesReader
    private let messagesLoader: MessagesLoader
    private let dialogActivator: DialogActivator
    private let currnetUserLoader: CurrnetUserLoader
    
    init(currendDialog: Dialog,
         currnetUserLoader: CurrnetUserLoader,
         messagesSender: MessagesSender,
         messagesReader: MessagesReader,
         messagesLoader: MessagesLoader,
         dialogActivator: DialogActivator) {
        self.currnetUserLoader = currnetUserLoader
        self.messagesSender = messagesSender
        self.messagesReader = messagesReader
        self.messagesLoader = messagesLoader
        self.currendDialog = currendDialog
        self.dialogActivator = dialogActivator
    }
}

extension ChatRoom: ChatRoomProtocol {
    func add<Observer: ChatRoomObserver>(observer: Observer) {
        let pointer = Unmanaged.passUnretained(observer).toOpaque()
        delegates.addPointer(pointer)
    }
    
    func join(completion: @escaping (Error?) -> Void) {
        dialogActivator.join(to: currendDialog, completion: completion)
    }
    
    func send(_ message: Message, completion: @escaping (Error?) -> Void) {
        messagesSender.send(message, in: currendDialog, completion: completion)
    }

    func read(_ message: Message, completion: @escaping (Error?) -> Void) {
        messagesReader.read([message], dialog: currendDialog, completion: completion)
    }
    
    func load(limit: Int, skip: Int, completion: @escaping (Result<GetMessagesResponse, Error>) -> Void) {
        messagesLoader.messages(for: currendDialog, skip: skip, limit: limit, extendedRequest: nil, completion: completion)
    }
}

extension ChatRoom: ChatRoomDelegate {
    func receive(_ message: Message) {
        delegates.allObjects
            .compactMap { $0 as? ChatRoomObserver }
            .forEach { $0.didRecieve(message) }
    }
}
