//
//  ChatViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.05.2021.
//

import Foundation
import MessageKit

fileprivate struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

fileprivate struct ChatMessage: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}


protocol ChatModelDelegate: AnyObject {
    func didFinishFetchData(at indexes: [Int])
}

final class ChatViewController: MessagesViewController {
    private let currentUser: SenderType
    private var messages = [MessageType]()
    
    init(currentUser: ChatConnectable, dialog: Dialog) {
        self.currentUser = Sender(senderId: "\(currentUser.userID)",
                                  displayName: currentUser.fullName)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}

extension ChatViewController: MessagesDisplayDelegate {  
}

extension ChatViewController: MessagesLayoutDelegate {
}
