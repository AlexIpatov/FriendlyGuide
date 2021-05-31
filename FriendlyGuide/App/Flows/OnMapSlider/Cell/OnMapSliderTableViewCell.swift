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
        if type(of: value) == MocPlace.self {
        guard let place: MocPlace = value as? MocPlace else { return }
            placeOrEventLabel.text = place.title
        } else if type(of: value) == MocEvent.self {
            guard let event: MocEvent = value as? MocEvent else { return }
            placeOrEventLabel.text = event.title
        }
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
