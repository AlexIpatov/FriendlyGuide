//
//  PlaceDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct PlaceDetail: Codable, Hashable {
    let title: String
    let address: String?
    let bodyText: String?
    let description: String?
    let timetable: String?
    let phone: String?
    let coords: Coordinates?
    let subway: String?
    let images: [Image]
    let isClosed: Bool?
    let categories: [String]?
    let siteUrl: String?

    enum CodingKeys: String, CodingKey {
        case title, address, timetable, phone
        case bodyText = "body_text"
        case siteUrl = "site_url"
        case description = "description"
        case coords, subway, images
        case isClosed = "is_closed"
        case categories
    }
}
