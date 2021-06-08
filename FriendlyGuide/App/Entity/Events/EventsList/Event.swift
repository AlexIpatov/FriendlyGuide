//
//  Event.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct Event: Codable, Hashable {
    let id: Int
    let title: String
    let dates: [DateElement]
    let images: [Image]
    let place: EventPlace?
}
