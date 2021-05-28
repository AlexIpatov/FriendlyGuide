//
//  UITextField + Extensions.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String,
                     font: UIFont?,
                     borderStyle: UITextField.BorderStyle,
                     adjustsFontSizeToFitWidth: Bool = false) {
        self.init()
        self.placeholder = placeholder
        self.font = font
        self.borderStyle = borderStyle
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
    }
}
