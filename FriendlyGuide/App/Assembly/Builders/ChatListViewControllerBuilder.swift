//
//  ChatListViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

final class ChatListViewControllerBuilder {
    
    private let requestFactory: RequestFactory
    
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func build(with frame: CGRect) -> (ChatListViewDelegate &
                                       ChatListModelDelegate &
                                       UIViewController) {
        
        let model = ChatListModel(getDialogsRequestFactory: requestFactory
                                    .makeGetDialogsRequestFactory())
        let view = ChatListView(frame: frame)
        
        
        let controller = ChatListViewController(customView: view,
                                                model: model)
        
        view.delegate = controller
        model.delegate = controller
        return controller
    }
}
