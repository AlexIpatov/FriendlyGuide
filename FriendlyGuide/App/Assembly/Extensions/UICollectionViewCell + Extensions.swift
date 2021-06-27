//
//  UICollectionViewCell + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 09.06.2021.
//

import UIKit

extension UICollectionViewCell {
    func makeRoundedCellWithShadow() {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 6
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.3
    }
}
