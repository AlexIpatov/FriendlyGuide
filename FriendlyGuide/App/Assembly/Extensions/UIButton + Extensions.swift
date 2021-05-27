//
//  UIButton+ Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

extension UIButton {
    convenience init(title: String? = nil,
                     image: UIImage? = nil,
                     font: UIFont?,
                     cornerRadius: CGFloat,
                     backgroundColor: UIColor = .clear,
                     tintColor: UIColor = .black) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = tintColor
        self.layer.masksToBounds = true

//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowRadius = 4
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}
