//
//  UIScrollView + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import UIKit

extension UIScrollView {
    convenience init(isScrollEnabled: Bool) {
        self.init()
        self.isScrollEnabled = isScrollEnabled
        self.showsVerticalScrollIndicator = true
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = false
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
