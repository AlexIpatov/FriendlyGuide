//
//  ChatListViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 24.05.2021.
//

import UIKit

class ChatListViewController: UIViewController {

    private var customView: ChatListView
    private var model: ChatListModel
    
    init(view: ChatListView, model: ChatListModel) {
        self.customView = view
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = view
        
        self.customView.delegate = self
        self.model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ChatListViewController

extension ChatListViewController: ChatListViewConnectable {
    func numberOfDialogs() -> Int {
        model.numberOfDialogs()
    }
    
    func dialog(at index: Int) -> Dialog {
        model.dialog(at: index)
    }
    
    func tapOnDialog(at index: Int) {
        let dialog = model.dialog(at: index)
        // TODO
    }
}

extension ChatListViewController: ChatListModelConnectable {
    func didFinishedRecieveData(at indexes: [Int]) {
        customView.updateUI(at: indexes)
    }
}



