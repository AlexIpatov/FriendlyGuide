//
//  DetailDescriptionCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import UIKit

class DetailDescriptionCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseId: String = "DetailDescriptionCell"

    private(set) lazy var descriptionlabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 0,
                                               textAlignment: .left)
    private(set) lazy var dateslabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 1,
                                               textAlignment: .left)
    private(set) lazy var pricelabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .darkGray,
                                               numberOfLines: 1,
                                               textAlignment: .left)
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    func configure<U>(with value: U) where U : Hashable {
        guard let entity: EventDetail = value as? EventDetail else { return }
        descriptionlabel.text = entity.description
        dateslabel.datesToString(dateElement: entity.dates.last)
        if entity.isFree ?? false {
            setupFreeLabel()
        } else {
            pricelabel.text = entity.price
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup free label
    private func setupFreeLabel() {
        pricelabel.text = "Бесплатно"
        pricelabel.font = .boldTitleFont()
    }

    // MARK: - Setup constraints
    private func setupConstraints() {
        contentView.addSubview(descriptionlabel)
        contentView.addSubview(pricelabel)
        contentView.addSubview(dateslabel)
        NSLayoutConstraint.activate([
            descriptionlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            descriptionlabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            descriptionlabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            dateslabel.topAnchor.constraint(equalTo: descriptionlabel.bottomAnchor, constant: 5),
            dateslabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dateslabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            pricelabel.topAnchor.constraint(equalTo: dateslabel.bottomAnchor, constant: 5),
            pricelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pricelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            pricelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
}
