//
//  ChatListViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import UIKit

protocol ChatListViewDelegate: AnyObject {
    func fetchData(at index: Int) -> Dialog?
    func numberOfRowsInSection() -> Int
}

protocol ChatListModelDelegate: AnyObject {
    func didFinishFetchData(at indexes: [Int])
}

final class ChatListViewController: UIViewController {
    private var customView: ChatListViewRepresentable
    private var model: ChatListModelRepresentable
    init(customView: ChatListViewRepresentable & UIView,
         model: ChatListModelRepresentable) {
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

