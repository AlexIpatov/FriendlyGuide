//
//  ChatListViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 24.05.2021.
//

import UIKit

class ChatListViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
}

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension ChatListViewController: UITableViewDelegate {
    
}
