//
//  SelfConfiguringCell.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 24.05.2021.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}
