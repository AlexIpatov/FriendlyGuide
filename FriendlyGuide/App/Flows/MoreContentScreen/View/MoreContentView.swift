//
//  MoreContentView.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 17.06.2021.
//

import UIKit

class MoreContentView: UIView {
    // MARK: - UI components
    var refreshControl = UIRefreshControl(title: "Загрузка...")

    var cityNameView = UIButton(title: "Выберите город",
                                image: UIImage(systemName: "flag"),
                                font: .smallButtonFont(),
                                cornerRadius: 0,
                                tintColor: .darkGray)

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds,
                                              collectionViewLayout: createFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.refreshControl = refreshControl
        addSubview(collectionView)
        return collectionView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Set up layout
extension MoreContentView {
    private func createFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: self.bounds.width,
                                          height: self.bounds.width)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        return layout
    }
}
