//
//  AuthViewsParametrs.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 03.06.2021.
//

import UIKit

struct AuthViewsParametrs {
    static let cornerRadius: CGFloat = 10
    
    static let borderWidth: CGFloat = 1
    static let borderColor: CGColor = UIColor.black.cgColor
    
    
    static let shadowOpacity: Float = 1
    static let shadowColor: CGColor = UIColor.gray.cgColor
    static let shadowRadius: CGFloat = 10
    static let shadowOffset: CGSize = .zero
    
    
    static let buttonHeight: CGFloat = 50
    static let buttonBackgroundColor: UIColor = .systemBlue
    static let buttonTitleColor: UIColor = .white
    
    static let textFieldsSpacing: CGFloat = 0
    static let textFieldsButtonsSpacing: CGFloat = 30
    static let buttonsSpacing: CGFloat = 20
    
    static let textFieldHeight: CGFloat = 45
    static let textFieldBackgroundColor: UIColor = .white
    
    
    static var placeholderInsetsView: UIView {
        UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                             size: CGSize(width: 30, height: 1)))
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
    
    static func placeholderInsetsImageView(with name: String) -> UIView {
        let imageView = UIImageView(image: UIImage(systemName: name,
                                               withConfiguration: UIImage
                                                .SymbolConfiguration(font: .systemFont(ofSize: 15))))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let insetsView = UIView()
        insetsView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: insetsView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: insetsView.centerYAnchor),
            
            insetsView.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        return insetsView
    }
}
