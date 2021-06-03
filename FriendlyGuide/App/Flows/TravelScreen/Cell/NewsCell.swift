//
//  NewsCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit
import Kingfisher

class NewsCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Cell ID
    static var reuseId: String = "NewsCell"

    // MARK: - UI components
    private(set) lazy var titlelabel = UILabel(text: "",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 3,
                                               textAlignment: .left,
                                               adjustsFontSizeToFitWidth: true)

    private(set) lazy var subTitlelabel = UILabel(text: "",
                                               font: .subTitleFont(),
                                               textColor: .systemGray,
                                               numberOfLines: 1,
                                               textAlignment: .left
                                              )

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
        guard let news: News = value as? News else { return }
        titlelabel.text = news.title
        subTitlelabel.text = news.description
        imageView.kf.setImage(with: URL(string: news.images.first?.image ?? ""))
    }
    // MARK: - Configuration Methods
    private func setupLayer() {
        backgroundColor = .white
    }
    private func setupConstraints() {
        addSubview(imageView)
        addSubview(titlelabel)
        addSubview(subTitlelabel)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.widthAnchor.constraint(equalTo: heightAnchor),

            titlelabel.topAnchor.constraint(equalTo: topAnchor),
            titlelabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 7),
            titlelabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),

            subTitlelabel.topAnchor.constraint(equalTo: titlelabel.bottomAnchor, constant: 4),
            subTitlelabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5),
            subTitlelabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
           // subTitlelabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
}
