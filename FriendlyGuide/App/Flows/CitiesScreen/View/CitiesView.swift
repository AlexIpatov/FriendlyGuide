//
//  CitiesView.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

class CitiesView: UIView {
    // MARK: - UI components
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = .white
        tableView.rowHeight = 40
        tableView.separatorStyle = .singleLine
        addSubview(tableView)
        return tableView
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
