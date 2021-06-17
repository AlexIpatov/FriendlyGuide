//
//  Dialog.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 27.05.2021.
//

import Foundation

protocol Dialog {
    var dialogId: String { get }
    var dialogName: String { get set }
    
    var dialogLastMessageText: String { get set }
    var dialogLastMessageUserId: UInt { get set }
    
    var dialogImageURL: URL? { get set }
}

