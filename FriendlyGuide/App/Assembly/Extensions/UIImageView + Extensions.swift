//
//   UIImageView + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init()
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    convenience init(systemImageName: String, tintColor: UIColor) {
        self.init()
        self.image = UIImage(systemName: systemImageName)
        self.setImageColor(color: tintColor)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - func for change color of the system image
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
}
