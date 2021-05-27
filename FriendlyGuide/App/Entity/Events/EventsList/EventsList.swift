//
//  EventsList.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventsList: Codable, Hashable {
    let count: Int
    let next: String
    let previous: String?
    let results: [Event]
}
