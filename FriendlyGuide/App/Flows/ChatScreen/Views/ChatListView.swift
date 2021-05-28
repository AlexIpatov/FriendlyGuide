//
//  ChatListView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

protocol ChatListView: UIView {
    var delegate: ChatListViewConnectable? { get set }

    func updateUI(at indexes: [Int])
}
