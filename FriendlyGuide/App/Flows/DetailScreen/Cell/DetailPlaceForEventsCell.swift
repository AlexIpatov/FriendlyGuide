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
    // TODO Добавтить переход на детэйл место
    private(set) lazy var placeNameLabel = UILabel(text: "",
                                                   font: .titleFont(),
                                                   textColor: .black,
                                                   numberOfLines: 2,
                                                   textAlignment: .center)
    private(set) lazy var subwayButton = UIButton(title: "",
                                                  image: UIImage(systemName: "tram"),
                                                  font: .smallButtonFont(),
                                                  cornerRadius: 0,
                                                  backgroundColor: .clear,
                                                  tintColor: .systemGray)
    private(set) lazy var addressButton = UIButton(title: "",
                                                   image: UIImage(systemName: "mappin"),
                                                   font: .smallButtonFont(),
                                                   cornerRadius: 0,
                                                   backgroundColor: .clear,
                                                   tintColor: .systemGray)
    private(set) lazy var phoneButton = UIButton(title: "",
                                                 image: UIImage(systemName: "phone"),
                                                 font: .smallButtonFont(),
                                                 cornerRadius: 0,
                                                 backgroundColor: .clear,
                                                 tintColor: .systemGray)
    private(set) lazy var showInWebButton = UIButton(title: "Показать на сайте",
                                                     image: UIImage(systemName: "network"),
                                                     font: .smallButtonFont(),
                                                     cornerRadius: 0,
                                                     backgroundColor: .clear,
                                                     tintColor: .systemGray)
    // MARK: - Properties
    private let constantForConstraints: CGFloat = 7
    private var siteURLInString: String?
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupConstraints()
        addTargets()
        self.makeRoundedCellWithShadow()
    }
    func configure<U>(with value: U) where U : Hashable {
        guard let place: EventPlace = value as? EventPlace else { return }
        placeNameLabel.text = place.title
        subwayButton.setTitle(setupPlaceInfoLabel(entity: place.subway,
                                                  addressType: .subway),
                              for: .normal)
        addressButton.setTitle(setupPlaceInfoLabel(entity: place.address,
                                                   addressType: .address),
                               for: .normal)
        phoneButton.setTitle(setupPlaceInfoLabel(entity: place.phone,
                                                 addressType: .phone),
                             for: .normal)
        siteURLInString = place.siteURL
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup PlaceInfoLabel
    func setupPlaceInfoLabel(entity: String?,
                             addressType: AddressType) -> String {
        guard let entity = entity,
              entity != "" else {
            return " - "
        }
        return "\(addressType.description()) \(entity)"
    }
    // MARK: - Setup constraints
    private func setupConstraints() {
        contentView.addSubview(placeNameLabel)
        contentView.addSubview(subwayButton)
        contentView.addSubview(addressButton)
        contentView.addSubview(phoneButton)
        contentView.addSubview(showInWebButton)
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constantForConstraints),
            placeNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            placeNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            subwayButton.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor, constant: constantForConstraints),
            subwayButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            
            addressButton.topAnchor.constraint(equalTo: subwayButton.bottomAnchor, constant: constantForConstraints),
            addressButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            
            phoneButton.topAnchor.constraint(equalTo: addressButton.bottomAnchor, constant: constantForConstraints),
            phoneButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            
            showInWebButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: constantForConstraints),
            showInWebButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: constantForConstraints),
            showInWebButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constantForConstraints)
        ])
    }
}
//MARK: - Actions
extension DetailPlaceForEventsCell {
    func addTargets() {
        showInWebButton.addTarget(self,
                                  action: #selector(showInWebButtonTapped),
                                  for: .touchUpInside)
        phoneButton.addTarget(self,
                              action: #selector(phoneButtonTapped),
                              for: .touchUpInside)
    }
    // MARK: - Open in web
    @objc private func showInWebButtonTapped() {
        guard let siteURLInString = siteURLInString,
              let siteURL = URL(string: siteURLInString)
        else {
            return
        }
        UIApplication.shared.open(siteURL,
                                  options: [:],
                                  completionHandler: nil)
    }
    // MARK: - Phone call (only device)
    @objc private func phoneButtonTapped() {
        guard let phoneNumber = phoneButton.title(for: .normal),
              let phoneNumberURL = URL(string: "tell://\(phoneNumber)")
        else {
            return
        }
        UIApplication.shared.open(phoneNumberURL,
                                  options: [:],
                                  completionHandler: nil)
    }
}
