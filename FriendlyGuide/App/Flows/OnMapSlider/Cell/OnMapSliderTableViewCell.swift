//
//  OnMapSliderTableViewCell.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit

class OnMapSliderTableViewCell: UITableViewCell, SelfConfiguringCell {
    // MARK: Cell ID
    static var reuseId: String = "OnMapSliderTableViewCell"
    
    // MARK: - UI components
    private(set) lazy var placeOrEventLabel = UILabel(text: "",
                                        font: .smallTitleFont(),
                                        textColor: .black,
                                        textAlignment: .left)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Configuration Methods
    func configure<U>(with value: U) where U : Hashable {
        guard let city: MocPlacesAndEvents = value as? MocPlacesAndEvents else { return }
        placeOrEventLabel.text = city.name
    }
    
    private func configureUI() {
        backgroundColor = .white
   
        contentView.addSubview(placeOrEventLabel)
        NSLayoutConstraint.activate([
            placeOrEventLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            placeOrEventLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
        ])
    }
}
