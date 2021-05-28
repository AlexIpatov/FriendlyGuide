//
//  QBChatListModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation
import Quickblox

struct QBChatListModel: ChatListModel {
    
    private var dialogs = [QBChatDialog]()
    
    weak var delegate: ChatListModelConnectable?
    
    func getDialog(at indexPath: IndexPath) -> Dialog {
        return QBDialogWrapper()
    }
    
    func getNumberOfDialogs() -> Int {
        0
    }
}
