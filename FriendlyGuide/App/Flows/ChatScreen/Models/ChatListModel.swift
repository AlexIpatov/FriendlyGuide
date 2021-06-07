//
//  ChatListModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatListModelRepresentable: AnyObject {
    var delegate: ChatListModelDelegate? { get set }
    
    func fetchData(at index: Int) -> Dialog
    func numberOfRowsInSection() -> Int
}

final class ChatListModel {
    
    private var dialogs = [Dialog]()
    private var totalNumderOfDialogs = 0
    
    private var isRequestAlreadySended: Bool = false
    
    weak var delegate: ChatListModelDelegate?
    private let chatDialogsManager: ChatDialogsManager
    init(chatDialogsManager: ChatDialogsManager) {
        self.chatDialogsManager = chatDialogsManager
    }
}

extension ChatListModel: ChatListModelRepresentable {
    func fetchData(at index: Int) -> Dialog {
        if index.distance(to: dialogs.count) > 3 &&
            dialogs.count != totalNumderOfDialogs { getMoreDialogs() }
        return dialogs[index]
    }
    
    func numberOfRowsInSection() -> Int {
        print("numberOfRowsInSection")
        if dialogs.count == .zero { getMoreDialogs() }
        return dialogs.count 
    }
    
    private func getMoreDialogs() {
        if !isRequestAlreadySended {
            isRequestAlreadySended = true
            
            chatDialogsManager.getDialogs(limit: 20,
                                          skipFirst: dialogs.count) { [weak self] (dialogs, total) in
                
                guard let self = self else {
                    return
                }
                
                let numberOfDialogsBeforUpdate = self.dialogs.count
                dialogs.forEach { self.dialogs.append($0) }
                self.totalNumderOfDialogs = total
                
                let indexes = Array(numberOfDialogsBeforUpdate..<self.dialogs.count)
                self.delegate?.didFinishFetchData(at: indexes)
                self.isRequestAlreadySended = false
            }
        }
    }
}
