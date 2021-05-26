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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 24
        addSubview(tableView)
        return tableView
    }()
    private(set) lazy var canсelButton =  UIButton(title: "Отмена",
                                                    font: .bigButtonFont(),
                                                    cornerRadius: 0,
                                                    backgroundColor: .clear,
                                                    tintColor: .systemRed)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlur()
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration Methods
    func configureUI() {
        addSubview(tableView)
        addSubview(canсelButton)

        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            tableView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6),

            canсelButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 5),
            canсelButton.rightAnchor.constraint(equalTo: tableView.rightAnchor),
            canсelButton.leftAnchor.constraint(equalTo: tableView.leftAnchor)
        ])
    }
    // MARK: - Set up blur
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
}
