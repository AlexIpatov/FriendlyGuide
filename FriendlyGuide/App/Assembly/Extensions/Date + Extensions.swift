//
//  Date + Extensions.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 26.06.2021.
//

import Foundation

extension Date {
    func goToSimpleDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: self)
    }
}
