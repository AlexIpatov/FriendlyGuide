//
//  ChatListView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 07.06.2021.
//

import UIKit

protocol ChatListViewRepresentable: AnyObject {
    var delegate: ChatListViewDelegate? { get set }
    
    func didFinishFetchData(at indexes: [Int])
}

final class ChatListView: UIView {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.bounds, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        
        table.register(ChatListViewEmptyCell.self,
                       forCellReuseIdentifier: ChatListViewEmptyCell.identifier)
        table.register(ChatListViewCell.self,
                       forCellReuseIdentifier: ChatListViewCell.identifier)
        return table
    }()
    
    weak var delegate: ChatListViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.addSubview(tableView)
    }
}

extension ChatListView: UITableViewDelegate {
    
}

extension ChatListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dialog = delegate?.fetchData(at: indexPath.row) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListViewCell.identifier),
                  let chatListCell = cell as? ChatListViewCell else {
                fatalError()
            }
            chatListCell.setUp(with: dialog)
            return chatListCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListViewEmptyCell.identifier),
                  let emptyCell = cell as? ChatListViewEmptyCell else {
                fatalError()
            }
            return emptyCell
        }
    }
}

extension ChatListView: ChatListViewRepresentable {
    func didFinishFetchData(at indexes: [Int]) {
        tableView.reloadRows(at: indexes.map { IndexPath(row: $0, section: 0) },
                             with: .automatic)
    }
}
