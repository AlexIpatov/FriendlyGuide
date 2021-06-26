//
//  ChatViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.05.2021.
//

import Foundation
import MessageKit
import InputBarAccessoryView

protocol ChatViewModelDelegate: AnyObject {
    func didFinishFetchData(at indexes: [Int])
    
    func present(error: Error)
}

final class ChatViewController: MessagesViewController {
    
    private let errorTimeredView = TimeredLableView(style: .error)
    private var model: ChatViewModelRepresentable
    
    init(model: ChatViewModelRepresentable) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureAdditionalParametrs()
        self.configure(self.messagesCollectionView)
        self.configure(self.navigationController)
        self.configure(self.messageInputBar)
        
        model.joinDialog { [weak self] error in
            error.map { self?.present(error: $0) }
        }
    }
    
    private func configureAdditionalParametrs() {
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
    }
    
    private func configure(_ messagesCollectionView: MessagesCollectionView) {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messagesCollectionView.keyboardDismissMode = .interactive
        title = model.dialogName
    }
    
    private func configure(_ messageInputBar: InputBarAccessoryView) {
        messageInputBar.delegate = self
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        
        configure(messageInputBar.inputTextView)
        configure(messageInputBar.sendButton)
    }
        
    private func configure(_ inputTextView: InputTextView) {
        inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        inputTextView.backgroundColor = .white
        
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 16
        
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        inputTextView.placeholder = "Message"
    }
    
    private func configure(_ sendButton: InputBarSendButton) {
        sendButton.backgroundColor = .primaryColor
        sendButton.layer.cornerRadius = 16
        sendButton.clipsToBounds = true
        
        sendButton.image = UIImage(systemName: "arrow.up")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        sendButton.title = nil
    }
    
    private func configure(_ navigationController: UINavigationController?) {
        configure(navigationController?.navigationBar)
    }
    
    private func configure(_ navigationBar: UINavigationBar?) {
        navigationBar?.isTranslucent = false
        navigationBar?.tintColor = .white
        navigationBar?.barTintColor = .primaryColor
        navigationBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar?.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBar?.shadowImage = UIImage()
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        model.currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        model.message(at: indexPath.row)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        model.numberOfMessages()
    }
}

extension ChatViewController: MessageCellDelegate {
    
}

extension ChatViewController: MessagesDisplayDelegate {
    
}

extension ChatViewController: MessagesLayoutDelegate {
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(inputBar)
    }
    
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        
        self.insertMessages(components) { [weak self] in
            inputBar.sendButton.stopAnimating()
            inputBar.inputTextView.placeholder = "Message"
            self?.messagesCollectionView.scrollToLastItem(animated: true)
            self?.messagesCollectionView.reloadData()
        }
    }
    
    private func insertMessages(_ data: [Any], completion: @escaping () -> Void) {
        for component in data {
            switch component {
            case let str as String:
                let message = Message(sentDate: Date(),
                                      messageSender: model.currentUser,
                                      messageText: str,
                                      messageId: "",
                                      dialogId: "")
                
                model.send(message: message, completion: completion)
            default:
                return
            }
        }
    }
}

extension ChatViewController: ChatViewModelDelegate {
    func present(error: Error) {
        errorTimeredView.show(in: self.view,
                              y: 100,
                              with: error,
                              duration: 2)
    }

    func didFinishFetchData(at indexes: [Int]) {
      
    }
}
