//
//  AuthViewsParametrs.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 03.06.2021.
//

import UIKit

struct AuthViewsParametrs {
    static let cornerRadius: CGFloat = 10
    
    static let borderWidth: CGFloat = 4
    static let borderColor: CGColor = UIColor.black.cgColor
    
    
    static let shadowOpacity: Float = 1
    static let shadowColor: CGColor = UIColor.gray.cgColor
    static let shadowRadius: CGFloat = 10
    
    
    static let buttonBackgroundColor: UIColor = .white
    
    
    static let textFieldsSpacing: CGFloat = 0
    static let textFieldsButtonsSpacing: CGFloat = 20
    static let buttonsSpacing: CGFloat = 10
    
    static let textFieldHeight: CGFloat = 50
    
    
    static var placeholderInsetsView: UIView {
        UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                             size: CGSize(width: 10, height: 1)))
    }
    
    static var separatorView: UIView {
        let separatorView = UIView()
        separatorView.backgroundColor = .black
        separatorView.isUserInteractionEnabled = false
        separatorView.heightAnchor
            .constraint(equalToConstant: AuthViewsParametrs.borderWidth)
            .isActive = true
        return separatorView
    }
}
