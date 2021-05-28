//
//  EventCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit
import Kingfisher

class EventCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Cell ID
    static var reuseId: String = "EventCell"

    // MARK: - UI components
    private(set) lazy var titlelabel = UILabel(text: "TestNameForEVENTLargeTestadwdawaw",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 2,
                                               textAlignment: .left)
    private(set) lazy var subTitlelabel = UILabel(text: "TestNameForEVENTLargeTestadwdawaw",
                                               font: .subTitleFont(),
                                               textColor: .systemGray,
                                               numberOfLines: 2,
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
    guard let event: Event = value as? Event else { return }
        titlelabel.text = event.title
        imageView.kf.setImage(with: URL(string: event.images.first))
        subTitlelabel.datesToString(dateElement: event.dates.first)

    }
    // MARK: - Configuration Methods
    private func setupLayer() {
        backgroundColor = .white
    }
    private func setupConstraints() {
    addSubview(titlelabel)
    addSubview(subTitlelabel)
    addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: widthAnchor),

            titlelabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titlelabel.leftAnchor.constraint(equalTo: leftAnchor),
            titlelabel.rightAnchor.constraint(equalTo: rightAnchor),

            subTitlelabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5),
            subTitlelabel.leftAnchor.constraint(equalTo: leftAnchor),
            subTitlelabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
