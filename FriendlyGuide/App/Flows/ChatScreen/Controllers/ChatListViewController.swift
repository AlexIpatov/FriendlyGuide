//
//  ChatListViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 24.05.2021.
//

import UIKit

class ChatListViewController: UIViewController {

    var customView: ChatListView
    var model: ChatListModel
    
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
    func numberOfRowsInSection(section: Int) -> Int {
        model.getNumberOfDialogs()
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Dialog {
        model.getDialog(at: indexPath)
    }
}

extension ChatListViewController: ChatListModelConnectable {
    func didFinishedRecieveData(at indexPaths: [IndexPath]) {
        customView.updateUI(at: indexPaths)
    }
}



