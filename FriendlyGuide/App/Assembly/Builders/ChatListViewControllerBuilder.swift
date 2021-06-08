//
//  ChatListViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

final class ChatListViewControllerBuilder {
    func build(with frame: CGRect) -> (ChatListViewDelegate &
                                       ChatListModelDelegate &
                                       UIViewController) {
        
        let model = ChatListModel(chatDialogsManager: QBChatManager())
        let view = ChatListView(frame: frame)
        
        let controller = ChatListViewController(customView: view,
                                                model: model)
        
        view.delegate = controller
        model.delegate = controller
        return controller
    }
}
