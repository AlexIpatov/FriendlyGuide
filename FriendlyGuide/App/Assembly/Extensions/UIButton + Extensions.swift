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
                     backgroundImageForNormalState: UIImage? = nil,
                     backgroundImageForHighlightedState: UIImage? = nil,
                     font: UIFont? = .smallButtonFont(),
                     cornerRadius: CGFloat? = 0.0,
                     backgroundColor: UIColor? = .clear,
                     tintColor: UIColor? = .systemBlue) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.setBackgroundImage(backgroundImageForNormalState, for: .normal)
        self.setBackgroundImage(backgroundImageForHighlightedState, for: .highlighted)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius ?? 0.0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = tintColor
        self.layer.masksToBounds = true

//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowRadius = 4
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
}
