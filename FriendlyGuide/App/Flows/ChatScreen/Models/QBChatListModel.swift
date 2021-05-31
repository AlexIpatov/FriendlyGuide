//
//  QBChatListModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation
import Quickblox

class QBChatListModel {
    
    private var dialogs = [Dialog]()
    private var manager: ChatManager {
        return QBChatManager.instance
    }
    
    weak var delegate: ChatListModelConnectable?
        
    private func outOfBounds(_ index: Int) -> Bool {
        index > dialogs.count
    }
    
    private func getMoreDialogs() {
        manager.getDialogs(limit: 10,
                           skipFirst: dialogs.count) { [weak self] dialogs in
            guard let self = self else{ return }
            
            let startIndex = self.dialogs.count
            let endIndex = self.dialogs.count + dialogs.count
            let appendedIndexes = Array(startIndex...endIndex)
            
            dialogs.forEach { self.dialogs.append($0) }
            self.delegate?.didFinishedRecieveData(at: appendedIndexes)
        }
    }
}

extension QBChatListModel: ChatListModel {
    func dialog(at index: Int) -> Dialog {
        if outOfBounds(index) || dialogs.isEmpty {
            getMoreDialogs()
            return Dialog.empty
        } else {
            return dialogs[index]
        }
    }
    
    func numberOfDialogs() -> Int {
        dialogs.count
    }
}
