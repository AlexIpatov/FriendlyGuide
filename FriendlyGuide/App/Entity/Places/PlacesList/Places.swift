//
//  Places.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct Places: Codable, Hashable {
    let id: Int
    let title, slug, address, phone: String
    let siteURL: String
    let subway: String
    let isClosed: Bool
    let location: String
    let hasParkingLot: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, slug, address, phone
        case siteURL = "site_url"
        case subway
        case isClosed = "is_closed"
        case location
        case hasParkingLot = "has_parking_lot"
    }
}
