//
//  DetailDescriptionCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import UIKit

class DetailDescriptionCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseId: String = "DetailDescriptionCell"

    private(set) lazy var bodyTextLabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 0,
                                               textAlignment: .left)
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    func configure<U>(with value: U) where U : Hashable {
        guard let bodyText: String = value as? String else { return }
        bodyTextLabel.text = bodyText
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - Setup constraints

    private func setupConstraints() {
        contentView.addSubview(bodyTextLabel)
        NSLayoutConstraint.activate([
            bodyTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bodyTextLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bodyTextLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            bodyTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5)

        ])

    }
}
