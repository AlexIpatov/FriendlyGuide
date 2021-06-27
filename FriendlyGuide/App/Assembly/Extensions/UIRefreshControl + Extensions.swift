//
//  UIRefreshControl + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 02.06.2021.
//

import UIKit

extension UIRefreshControl {
    convenience init(title: String) {
        self.init()
        self.tintColor = .blue
        self.attributedTitle =  NSAttributedString(string: title)
    }
}

