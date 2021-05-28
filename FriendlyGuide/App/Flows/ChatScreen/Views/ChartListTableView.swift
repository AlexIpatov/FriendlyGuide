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
    func updateUI(at indexes: [Int]) {
        tableView.reloadRows(at: indexes.map { IndexPath(row: $0, section: 0) },
                             with: .fade)
    }
}

extension ChartListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate?.numberOfDialogs() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dialogModel = delegate?.dialog(at: indexPath.row),
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
