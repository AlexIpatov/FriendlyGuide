//
//  DayEvents.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct DayEventsList: Codable, Hashable {
    let count: Int
    let next: Int?
    let previous: Int?
    let events: [DayEvent]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case events = "results"
    }
    }
