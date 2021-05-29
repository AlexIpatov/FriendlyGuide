//
//  CitiesCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

class CitiesCell: UITableViewCell, SelfConfiguringCell {

    // MARK: Cell ID
    static var reuseId: String = "CitiesCell"

    // MARK: - UI components
    private var cityNameLabel = UILabel(text: "",
                                        font: .smallTitleFont(),
                                        textColor: .black,
                                        textAlignment: .left)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        setupLayer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func configure<U>(with value: U) where U : Hashable {
        guard let city: CityName = value as? CityName else { return }
        cityNameLabel.text = city.name
    }
    //MARK: - Configuration Methods
    private func setupLayer() {
        backgroundColor = .white
    }
    private func setupConstraints() {
        contentView.addSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cityNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
        ])
    }
}
