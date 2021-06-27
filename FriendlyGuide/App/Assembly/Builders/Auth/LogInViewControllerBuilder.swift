//
//  LogInViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit

protocol LogInViewControllerBuilder {
    func build(with frame: CGRect) -> (LogInViewDelegate & UIViewController)
}
