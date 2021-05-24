//
//  UIComponentsMakeable.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import GoogleMaps

protocol UIComponentsMakeable: UIView {
    func makeScrollView() -> UIScrollView
    
    func makeMapView() -> GMSMapView
    
    func makeImageView(image: UIImage,
                                  tintColor: UIColor) -> UIImageView
    
    func makeLabel(text: String,
                        textColor: UIColor,
                        font: UIFont) -> UILabel
    
    func makeTextField(placeholder: String,
                            font: UIFont,
                            borderStyle: UITextField.BorderStyle) -> UITextField
    
    func makeButton(title: String,
                         font: UIFont,
                         backgroundColor: UIColor,
                         cornerRadius: CGFloat) -> UIButton
}

extension UIComponentsMakeable {
    func makeScrollView() -> UIScrollView {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
        return scrollView
    }
    
    func makeMapView() -> GMSMapView {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.sizeToFit()
        return mapView
    }
    
    func makeImageView(image: UIImage,
                                  tintColor: UIColor) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.image = image
        imageView.tintColor = tintColor
        return imageView
    }
    
    func makeLabel(text: String,
                        textColor: UIColor,
                        font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = textColor
        label.font = font
        return label
    }
    
    func makeTextField(placeholder: String,
                            font: UIFont,
                            borderStyle: UITextField.BorderStyle) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = borderStyle
        textField.placeholder = placeholder
        textField.font = font
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        return textField
    }
    
    func makeButton(title: String,
                         font: UIFont,
                         backgroundColor: UIColor,
                         cornerRadius: CGFloat) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        return button
    }
}
