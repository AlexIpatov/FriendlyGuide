//
//  DetailSectionHeader.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 06.06.2021.
//

import UIKit

class DetailSectionHeader: UICollectionReusableView {
    // MARK: - Properties
    static let reuseId = "DetailSectionHeader"
    // MARK: - UI components
    let showMoreButton = UIButton(title: "Подробнее о событии...",
                                                    font: .smallButtonFont(),
                                                    cornerRadius: 0.0,
                                                    backgroundColor: .clear,
                                                    tintColor: .systemGray)
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Configuration Methods
    func configureUI() {
        addSubview(showMoreButton)
        NSLayoutConstraint.activate([
            showMoreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            showMoreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            showMoreButton.heightAnchor.constraint(equalToConstant: 20)
        ])

    }
}

