//
//  DayEvents.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct DayEvent: Codable, Hashable {
    let date: String
    let location: String
    let eventData: EventType
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case location
        case eventData = "object"
        case title
    }
}
