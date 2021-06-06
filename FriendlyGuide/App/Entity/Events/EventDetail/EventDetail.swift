//
//  Event.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventDetail: Codable, Hashable {
    let dates: [DateElement]
    let title: String
    let shortTitle: String
    let place: EventPlace?
    let bodyText: String?
    let description: String?
    let categories: [String]?
    let ageRestriction: Int?
    let price: String?
    let isFree: Bool?
    let images: [Image]
    let siteURL: String?

    enum CodingKeys: String, CodingKey {
        case dates, title, place,description
        case shortTitle = "short_title"
        case bodyText = "body_text"
        case categories
        case ageRestriction = "age_restriction"
        case price
        case isFree = "is_free"
        case images
        case siteURL = "site_url"
    }
}



