//
//  ChartListTableView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

class ChartListTableView: UIView {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: bounds, style: .grouped)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    
    weak var delegate: ChatListViewConnectable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        addSubview(tableView)
    }
}

extension ChartListTableView: ChatListView {
    func updateUI(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .fade)
    }
}

extension ChartListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dialogModel = delegate?.cellForRowAt(indexPath: indexPath),
           let cell = tableView.dequeueReusableCell(withIdentifier: "") as? ChatTableVewCell {
            cell.fillIn(with: dialogModel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ChartListTableView: UITableViewDelegate {
    
}
