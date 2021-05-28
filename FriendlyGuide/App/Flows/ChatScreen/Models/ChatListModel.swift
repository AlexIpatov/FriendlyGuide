//
//  ChatListModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatListModel {
    var delegate: ChatListModelConnectable? { get set }
    
    func getDialog(at indexPath: IndexPath) -> Dialog
    func getNumberOfDialogs() -> Int
}
