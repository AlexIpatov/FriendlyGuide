//
//  TravelScreenEnum.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 24.05.2021.
//

import Foundation

enum TravelSection: Int, CaseIterable {
    case events, places, news

    func description() -> String {
        switch self {
        case .events:
            return "События"
        case .places:
            return "Интерсные места"
        case .news:
            return "Новости"
        }
    }
}
