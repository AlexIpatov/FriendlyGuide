//
//  DetailPlaceForEventsCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 06.06.2021.
//

import UIKit
import Kingfisher

enum AddressType {
    case address, subway, phone, siteURL

    func description() -> String {
        switch self {
        case .address:
            return "адрес:"
        case .subway:
            return "м."
        case .phone:
            return "тел.:"
        case .siteURL:
            return "сайт:"
        }
    }
}

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
        guard let place: EventPlace = value as? EventPlace else { return }
        placeNameLabel.text = place.title
        subwayLabel.text = setupPlaceInfoLabel(entity: place.subway, addressType: .subway)
        addressLabel.text = setupPlaceInfoLabel(entity: place.address, addressType: .address)
        phoneLabel.text = setupPlaceInfoLabel(entity: place.phone, addressType: .phone)
        urlLabel.text = setupPlaceInfoLabel(entity: place.siteURL, addressType: .siteURL)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupPlaceInfoLabel(entity: String?, addressType: AddressType) -> String? {
        guard let entity = entity,
              entity != "" else {
            return nil
        }
        return "\(addressType.description()) \(entity)"
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
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constantForConstraints),
            placeNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            placeNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            subwayLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: constantForConstraints),
            subwayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            subwayLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            addressLabel.topAnchor.constraint(equalTo: subwayLabel.bottomAnchor, constant: constantForConstraints),
            addressLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            addressLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor),

            phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: constantForConstraints),
            phoneLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            phoneLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor),

            urlLabel.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: constantForConstraints),
            urlLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            urlLabel.rightAnchor.constraint(equalTo:contentView.rightAnchor),
            urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constantForConstraints)

            //            showOnMapButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            //            showOnMapButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            //            showOnMapButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            //            showOnMapButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

