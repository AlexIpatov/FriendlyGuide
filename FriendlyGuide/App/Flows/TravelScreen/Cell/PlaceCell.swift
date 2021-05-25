//
//  PlaceCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

class PlaceCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Cell ID
    static var reuseId: String = "PlaceCell"

    // MARK: - UI components
    private(set) lazy var titlelabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .white,
                                               textAlignment: .left)
    private(set) lazy var imageView = UIImageView(cornerRadius: 20)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupLayer()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configure
    func configure<U>(with value: U) where U : Hashable {
      //  guard let place: MocPlace = value as? MocPlace else { return }
        imageView.backgroundColor = .blue
    }
    //MARK: - Configuration Methods
    private func setupLayer() {
        backgroundColor = .white
    }
    private func setupConstraints() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}



