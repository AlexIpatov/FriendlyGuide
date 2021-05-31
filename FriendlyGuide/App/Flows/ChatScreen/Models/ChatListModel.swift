//
//  ChatListModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatListModel: AnyObject {
    var delegate: ChatListModelConnectable? { get set }
    
    func dialog(at index: Int) -> Dialog
    func numberOfDialogs() -> Int
}
