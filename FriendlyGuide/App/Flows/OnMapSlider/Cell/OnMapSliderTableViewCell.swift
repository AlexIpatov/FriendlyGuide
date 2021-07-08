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
    
    private(set) lazy var cityNameLabel = UILabel(text: "",
                                        font: .smallTitleFont(),
                                        textColor: .systemGray,
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
        guard let placeOrEvent: EntityForAnnotation = value as? EntityForAnnotation else { return }
        placeOrEventLabel.text = placeOrEvent.title
        cityNameLabel.text = placeOrEvent.cityName
    }
    
    private func configureUI() {
        backgroundColor = .white
   
        contentView.addSubview(placeOrEventLabel)
        contentView.addSubview(cityNameLabel)
        
        NSLayoutConstraint.activate([
            placeOrEventLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10.0),
            placeOrEventLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            placeOrEventLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            
            cityNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 10.0),
            cityNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            cityNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0)
        ])
    }
}
