//
//  ChatControllersFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 18.06.2021.
//

import UIKit

final class ChatControllersFactory {
    
    private let requestFactory: RequestFactory
    
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
    }
}

extension ChatControllersFactory: ChatViewControllerBuilder {
    func build(for dialog: Dialog, with user: User) -> (UIViewController & ChatViewModelDelegate) {
        let model = ChatViewModel(dialog: dialog,
                                  user: user,
                                  getMessagesRequestFactory: requestFactory.makeMessagesLoader(),
                                  getUserRequestFactory: requestFactory.makeGetUserRequestFactory(),
                                  sendMessagesRequestFactory: requestFactory.makeMessagesSender(),
                                  joinDialogRequestFactory: requestFactory.makeDialogActivator())
        
        let controller = ChatViewController(model: model)
        
        model.delegate = controller
        return controller
    }
}

extension ChatControllersFactory: ChatListViewControllerBuilder {
    func build(with frame: CGRect) -> (ChatListViewDelegate &
                                       ChatListModelDelegate &
                                       UIViewController) {
        
        let model = ChatListModel(getDialogsRequestFactory: requestFactory
                                    .makeGetDialogsRequestFactory())
        let view = ChatListView(frame: frame,
                                dialogDataLoaader: requestFactory.makeDialogDataLoader())
        
        
        let controller = ChatListViewController(customView: view,
                                                model: model,
                                                chatViewControllerBuilder: self,
                                                getCurrnetUserREquestFactory: requestFactory.makeGetCurrnetUserREquestFactory())
        
        view.delegate = controller
        model.delegate = controller
        return controller
    }
}
