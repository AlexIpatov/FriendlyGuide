//
//  ChatListViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

class ChatListViewControllerBuilder {
    func build(withFrame frame: CGRect) -> (ChatListModelConnectable
                                            & ChatListViewConnectable
                                            & UIViewController) {
        ChatListViewController(view: buildView(frame: frame),
                               model: buildModel())
    }
    
    private func buildModel() -> ChatListModel {
        QBChatListModel()
    }
    
    private func buildView(frame: CGRect) -> ChatListView {
        ChartListTableView(frame: frame)
    }
}
