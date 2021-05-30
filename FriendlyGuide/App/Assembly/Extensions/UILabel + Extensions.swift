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
    
    func datesToString(dateElement: DateElement?) {
        guard let dateElement = dateElement else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let startStringDate = formatter.string(from: dateElement.start)
        let endStringDate = formatter.string(from: dateElement.end)
        
        self.text = String("\(startStringDate) - \(endStringDate)")
    }
}
