//
//  UIFont + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 24.05.2021.
//

import UIKit

 // TODO - Обсудить шрифты, пока заглушки
extension UIFont {
    static func smallButtonFont() -> UIFont {
        return UIFont.init(name: "Thonburi", size: 12)!
    }
    static func bigButtonFont() -> UIFont {
        return UIFont.init(name: "Thonburi", size: 16)!
    }
    static func smallTitleFont() -> UIFont {
        return UIFont.init(name: "Charter Roman", size: 17)!
    }
    static func subTitleFont() -> UIFont {
        return UIFont.init(name: "Charter Roman", size: 13)!
    }
    static func boldTitleFont() -> UIFont {
        return UIFont.init(name: "Thonburi-bold", size: 18)!
    }
    static func titleFont() -> UIFont {
        return UIFont.init(name: "Charter Roman", size: 18)!
    }
}

