//
//  EventPlace.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventPlace: Codable, Hashable {
    let title, address, phone: String?
    let subway: String?
    let siteURL: String?
    let isClosed: Bool?
    let coords: Coordinates?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case title, address, phone, subway
        case siteURL = "site_url"
        case isClosed = "is_closed"
        case coords
        case location
    }
}
