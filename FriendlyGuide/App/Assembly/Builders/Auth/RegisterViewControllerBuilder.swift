//
//  RegisterViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import UIKit

protocol RegisterViewControllerBuilder {
    func build(with frame: CGRect) -> (RegisterViewDelegate & UIViewController)
}
