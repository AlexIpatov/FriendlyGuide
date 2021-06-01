//
//  DetailNameCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import UIKit

class DetailNameCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Cell ID
    static var reuseId: String = "DetailNameCell"

    // MARK: - UI components
    private(set) lazy var titlelabel = UILabel(text: "",
                                               font: .titleFont(),
                                               textColor: .black,
                                               numberOfLines: 2,
                                               textAlignment: .left)
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
    guard let event: Event = value as? Event else { return }
        titlelabel.text = event.title
    }
    // MARK: - Configuration Methods
    private func setupLayer() {
        backgroundColor = .white
    }
    private func setupConstraints() {
    addSubview(titlelabel)
        NSLayoutConstraint.activate([
            titlelabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titlelabel.leftAnchor.constraint(equalTo: leftAnchor),
            titlelabel.rightAnchor.constraint(equalTo: rightAnchor),
            titlelabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
