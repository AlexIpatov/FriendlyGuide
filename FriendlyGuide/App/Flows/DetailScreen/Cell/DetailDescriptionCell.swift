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
                                               textAlignment: .center)
    private(set) lazy var subtitlelabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 2,
                                               textAlignment: .center)
    private(set) lazy var secondSubtitlelabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .darkGray,
                                               numberOfLines: 1,
                                               textAlignment: .left)
    // MARK: - Properties
    private let constantForConstraints: CGFloat = 7
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        self.makeRoundedCellWithShadow()
    }
    func configure<U>(with value: U) where U : Hashable {
        guard let entity: DescriptionForEntity = value as? DescriptionForEntity else { return }
        descriptionlabel.text = entity.description
        subtitlelabel.text = entity.firstSubtitle
        if entity.boolSubtitle ?? false {
            setupFreeLabel()
        } else {
            secondSubtitlelabel.text = entity.secondSubtitle
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup free label
    private func setupFreeLabel() {
        secondSubtitlelabel.text = "Бесплатно"
        secondSubtitlelabel.font = .boldTitleFont()
    }
    // MARK: - Setup constraints
    private func setupConstraints() {
        contentView.addSubview(descriptionlabel)
        contentView.addSubview(secondSubtitlelabel)
        contentView.addSubview(subtitlelabel)
        NSLayoutConstraint.activate([
            descriptionlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constantForConstraints),
            descriptionlabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            descriptionlabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -constantForConstraints),

            subtitlelabel.topAnchor.constraint(equalTo: descriptionlabel.bottomAnchor, constant: constantForConstraints),
            subtitlelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            subtitlelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -constantForConstraints),

            secondSubtitlelabel.topAnchor.constraint(equalTo: subtitlelabel.bottomAnchor, constant: constantForConstraints),
            secondSubtitlelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            secondSubtitlelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -constantForConstraints),
            secondSubtitlelabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constantForConstraints)
        ])
    }
}
