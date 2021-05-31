//
//  UISegmentedControl + Extensions.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 31.05.2021.
//

import UIKit

extension UISegmentedControl {
    convenience init(items: [String],
                     selectedSegmentIndex: Int,
                     backgroundColor: UIColor) {
        self.init(items: items)
        self.selectedSegmentIndex = selectedSegmentIndex
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
