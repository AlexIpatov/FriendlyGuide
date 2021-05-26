//
//  EventCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

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
                                               font: .smallTitleFont(),
                                               textColor: .systemGray,
                                               numberOfLines: 2,
                                               textAlignment: .left)

    private(set) lazy var imageView = UIImageView(cornerRadius: 20)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupLayer()
        titlelabel.backgroundColor = .red
        backgroundColor = .green
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure
    func configure<U>(with value: U) where U : Hashable {
//        guard let event: MocEvent = value as? MocEvent else { return }
       // titlelabel.text = event.title
        imageView.backgroundColor = .blue
        subTitlelabel.backgroundColor = .yellow
    }
    // MARK: - Configuration Methods
    private func setupLayer() {
        //backgroundColor = .white
    }
    private func setupConstraints() {
    contentView.addSubview(titlelabel)
    contentView.addSubview(subTitlelabel)
    contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            titlelabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titlelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titlelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            subTitlelabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 5),
            subTitlelabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            subTitlelabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
    }
}
