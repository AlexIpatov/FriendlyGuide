//
//  ChatListViewConnectable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatListViewConnectable: AnyObject {
    func numberOfDialogs() -> Int
    func dialog(at index: Int) -> Dialog
    func tapOnDialog(at index: Int)
}
