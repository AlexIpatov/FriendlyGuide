//
//  ChatListViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import UIKit

protocol ChatListViewDelegate: AnyObject {
    func didSelectDialog(at index: Int)
    
    func fetchData(at index: Int) -> Dialog?
    func numberOfRowsInSection() -> Int
}

protocol ChatListModelDelegate: AnyObject {
    func didFinishFetchData(at indexes: [Int])
}

final class ChatListViewController: UIViewController {
        
    private let getCurrnetUserREquestFactory: CurrnetUserLoader
    private let chatViewControllerBuilder: ChatViewControllerBuilder
    private var customView: ChatListViewRepresentable
    private var model: ChatListModelRepresentable
    
    init(customView: ChatListViewRepresentable & UIView,
         model: ChatListModelRepresentable,
         chatViewControllerBuilder: ChatViewControllerBuilder,
         getCurrnetUserREquestFactory: CurrnetUserLoader) {
        self.getCurrnetUserREquestFactory = getCurrnetUserREquestFactory
        self.chatViewControllerBuilder = chatViewControllerBuilder
        self.customView = customView
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatListViewController: ChatListViewDelegate {
    func didSelectDialog(at index: Int) {
        if let dialog = model.fetchData(at: index),
           let user = getCurrnetUserREquestFactory.currentUser {
            let chatVC = chatViewControllerBuilder.build(for: dialog, with: user)
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            debugPrint("Что-то пошло не так")
        }
    }
    
    func fetchData(at index: Int) -> Dialog? {
        model.fetchData(at: index)
    }
    
    func numberOfRowsInSection() -> Int {
        model.numberOfRowsInSection()
    }
}

extension ChatListViewController: ChatListModelDelegate {
    func didFinishFetchData(at indexes: [Int]) {
        customView.didFinishFetchData(at: indexes)
    }
}

