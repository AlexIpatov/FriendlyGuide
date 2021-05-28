//
//  UILabel+Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

extension UILabel {
    convenience init(text: String,
                     font: UIFont?,
                     textColor: UIColor = .black,
                     numberOfLines: Int = 0,
                     textAlignment: NSTextAlignment = .center,
                     adjustsFontSizeToFitWidth: Bool = false) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
}