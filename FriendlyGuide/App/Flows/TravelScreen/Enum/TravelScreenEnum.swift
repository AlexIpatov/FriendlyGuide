//
//  TravelScreenEnum.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 24.05.2021.
//

import Foundation

enum TravelSection: Int, CaseIterable {
    case city, events, places, news

    func description() -> String {
        switch self {
        case .city:
            return "City"
        case .events:
            return "События"
        case .places:
            return "Интерсные места"
        case .news:
            return "Новости"
        }
    }
}
