//
//  AuthView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

protocol AuthView: UIView {
    var delegate: AuthViewConnectable? { get set }
}
