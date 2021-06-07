//
//  DetailPlaceForEventsCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 06.06.2021.
//

import UIKit
import Kingfisher

class DetailPlaceForEventsCell: UICollectionViewCell, SelfConfiguringCell {

    static var reuseId: String = "DetailPlaceForEventsCell"

    private(set) lazy var placeNameLabel = UILabel(text: "",
                                                   font: .titleFont(),
                                                   textColor: .black,
                                                   numberOfLines: 2,
                                                   textAlignment: .center)
    private(set) lazy var subwayLabel = UILabel(text: "",
                                                font: .smallTitleFont(),
                                                textColor: .black,
                                                numberOfLines: 1,
                                                textAlignment: .left)
    private(set) lazy var addressLabel = UILabel(text: "",
                                                 font: .smallTitleFont(),
                                                 textColor: .black,
                                                 numberOfLines: 1,
                                                 textAlignment: .left)
    private(set) lazy var phoneLabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 1,
                                               textAlignment: .left)
    private(set) lazy var urlLabel = UILabel(text: "",
                                             font: .smallTitleFont(),
                                             textColor: .black,
                                             numberOfLines: 1,
                                             textAlignment: .left,
                                             adjustsFontSizeToFitWidth: true)

    let showOnMapButton = UIButton(title: "Показать на карте",
                                   image: UIImage(systemName: "map"),
                                   font: nil,
                                   cornerRadius: 0,
                                   backgroundColor: .clear,
                                   tintColor: .systemBlue)
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
    }
    func configure<U>(with value: U) where U : Hashable {
        guard let place: EventPlace = value as? EventPlace else { return }
        placeNameLabel.text = place.title
        subwayLabel.text = "м.\(place.subway ??  "  -  ")"
        addressLabel.text = place.address
        phoneLabel.text = "тел.\(place.phone ??  "  -  ")"
        urlLabel.text = place.siteURL
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup constraints
    private func setupConstraints() {
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(subwayLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(urlLabel)
        //  contentView.addSubview(showOnMapButton)
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            placeNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            placeNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            subwayLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: 5),
            subwayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            subwayLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            addressLabel.topAnchor.constraint(equalTo: subwayLabel.bottomAnchor, constant: 5),
            addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            addressLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor),

            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            phoneLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            phoneLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor),

            urlLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5),
            urlLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            urlLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor),
            urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            //            showOnMapButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            //            showOnMapButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            //            showOnMapButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            //            showOnMapButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

