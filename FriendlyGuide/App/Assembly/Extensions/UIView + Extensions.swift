//
//  UIView + Extensions.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 03.06.2021.
//

import UIKit

protocol Shakable {
    func shake()
}

extension UIView {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        animation.fromValue = CGPoint(x: center.x - 10,
                                      y: center.y)
        
        animation.toValue = CGPoint(x: center.x + 10,
                                    y: center.y)

        layer.add(animation, forKey: "position")
    }
}
