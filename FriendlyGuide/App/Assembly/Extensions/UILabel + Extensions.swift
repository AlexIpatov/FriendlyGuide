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
                     numberOfLines: Int? = 1,
                     textAlignment: NSTextAlignment = .center,
                     adjustsFontSizeToFitWidth: Bool = false) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines ?? 1
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
    func datesToString(dateElement: DateElement?) {
        guard let dateElement = dateElement,
              // Исключил заглушки в api
              dateElement.start != Date(timeIntervalSince1970: -62135433000),
              dateElement.end != Date(timeIntervalSince1970: 253370754000) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"

        let startStringDateInString = formatter.string(from: dateElement.start)
        let endStringDateInString = formatter.string(from: dateElement.end)

        self.text = String("\(startStringDateInString) - \(endStringDateInString)")
    }
}

