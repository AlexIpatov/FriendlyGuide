//
//  EventPlace.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventPlace: Codable, Hashable {
    let id: Int
    let title, slug, address, phone: String?
    let subway, location: String?
    let siteURL: String?
    let isClosed: Bool?
    let coords: Coordinates?
    let isStub: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, slug, address, phone, subway, location
        case siteURL = "site_url"
        case isClosed = "is_closed"
        case coords
        case isStub = "is_stub"
    }
}
