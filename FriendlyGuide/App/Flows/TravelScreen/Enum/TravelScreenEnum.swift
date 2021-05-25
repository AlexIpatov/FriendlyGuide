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
            return "Events"
        case .places:
            return "Places"
        case .news:
            return "News"
        }
    }
}
