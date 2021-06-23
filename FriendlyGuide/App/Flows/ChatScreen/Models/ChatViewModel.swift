//
//  ChatViewModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 13.06.2021.
//

import Foundation


protocol ChatViewModelRepresentable {
    var delegate: ChatModelDelegate? { get set }
    
    func fetchData(at index: Int) -> Message?
    func numberOfDialogs() -> Int
}

final class ChatViewModel {
    
    private var messages = [Message]()
    private var totalNumberOfMessages: Int = 0
    private var isRequestAlreadySended: Bool = false
    
    private let messagesRequestLimit: Int = 35
    
    private let dialog: Dialog
    private let user: ChatConnectable
    private let getMessagesRequestFactory: GetMessagesRequestFactory
    
    weak var delegate: ChatModelDelegate?
    
    init(dialog: Dialog, user: ChatConnectable,
         getMessagesRequestFactory: GetMessagesRequestFactory) {
        self.getMessagesRequestFactory = getMessagesRequestFactory
        self.dialog = dialog
        self.user = user
    }
}

extension ChatViewModel: ChatViewModelRepresentable {
    func fetchData(at index: Int) -> Message? {
        if index.distance(to: 5) < 3 {
            getMoreMessages()
        }
        
        if index.distance(to: messages.count) > 0 {
            return messages[index]
        }
        
        return nil
    }
    
    func numberOfDialogs() -> Int {
        if messages.count == .zero { getMoreMessages() }
        return totalNumberOfMessages
    }
    
    func getMoreMessages() {
        if !isRequestAlreadySended {
            isRequestAlreadySended = true
            
            getMessagesRequestFactory.messages(for: dialog,
                                               skip: messages.count,
                                               limit: messagesRequestLimit,
                                               extendedRequest: nil) { [weak self] messages, totalNumberOfMessages  in
                guard let self = self else { return }
                
                self.totalNumberOfMessages = totalNumberOfMessages
                let numberOfDialogsBeforUpdate = self.messages.count
                messages.forEach { self.messages.append($0) }
                
                let indexes = Array(numberOfDialogsBeforUpdate..<self.messages.count)
                self.delegate?.didFinishFetchData(at: indexes)
                self.isRequestAlreadySended = false
                
            } errorHandler: { error in
                debugPrint(error.localizedDescription)
            }
        }
    }
}
