//
//  SelectCityCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

class SelectCityCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: - Properties
    static let reuseId = "SelectCityCell"
    // MARK: - UI components
    private(set) lazy var pointerImageView = UIImageView(systemImageName: "mappin.and.ellipse",
                                                         tintColor: .systemBlue)

    let setCityLabel = UILabel(text: "Выберите город",
                                font: .smallButtonFont(),
                                textColor: .black,
                                numberOfLines: 1,
                                textAlignment: .center,
                                adjustsFontSizeToFitWidth: true)
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configure
    func configure<U>(with value: U) where U : Hashable {
        guard let city: MocCity = value as? MocCity else { return }
        setCityLabel.text = city.name
    }

    // MARK: - Configuration Methods
    func configureUI() {
        contentView.addSubview(pointerImageView)
        contentView.addSubview(setCityLabel)
        NSLayoutConstraint.activate([
            pointerImageView.rightAnchor.constraint(equalTo: setCityLabel.leftAnchor),
            pointerImageView.heightAnchor.constraint(equalTo: setCityLabel.heightAnchor),
            pointerImageView.widthAnchor.constraint(equalTo: pointerImageView.heightAnchor),
            pointerImageView.centerYAnchor.constraint(equalTo:setCityLabel.centerYAnchor),

            setCityLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            setCityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
