//
//  ChatListModelConnectable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol ChatListModelConnectable: AnyObject {
    func didFinishedRecieveData(at indexPaths: [IndexPath])
}
