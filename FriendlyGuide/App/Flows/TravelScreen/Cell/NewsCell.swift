//
//  NewsCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

class NewsCell: UICollectionViewCell, SelfConfiguringCell {

    // MARK: Cell ID
    static var reuseId: String = "NewsCell"

    // MARK: - UI components
    private(set) lazy var titlelabel = UILabel(text: "TestNameForEVENTLargeTestadwdawaw",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 2,
                                               textAlignment: .left,
                                               adjustsFontSizeToFitWidth: true)

    private(set) lazy var subTitlelabel = UILabel(text: "TestNameForEVENTLargeTestadwdawaw",
                                               font: .subTitleFont(),
                                               textColor: .systemGray,
                                               numberOfLines: 2,
                                               textAlignment: .left
                                              )

    private(set) lazy var imageView = UIImageView(cornerRadius: 35)

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
        guard let news: MocNews = value as? MocNews else { return }
        titlelabel.text = news.title
        imageView.image = UIImage(named: "mocImage")
    }
    // MARK: - Configuration Methods
    private func setupLayer() {
        backgroundColor = .white
    }
    private func setupConstraints() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

        ])
    }
}
