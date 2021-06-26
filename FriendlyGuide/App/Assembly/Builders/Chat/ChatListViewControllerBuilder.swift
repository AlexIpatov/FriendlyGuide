//
//  ChatListViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

protocol ChatListViewControllerBuilder {
    func build(with frame: CGRect) -> (ChatListViewDelegate &
                                       ChatListModelDelegate &
                                       UIViewController)
}
