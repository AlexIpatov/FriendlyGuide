//
//  Event.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventDetail: Codable, Hashable, DetailScreenRepresentable {
    let title: String
    let description: String?
    let firstSubtitle: String?
    let secondSubtitle: String?
    let boolSubtitle: Bool?
    let images: [Image]?
    let shortPlace: EventPlace?
    let bodyText: String?
    
    let dates: [DateElement]
    let shortTitle: String?
    let categories: [String]?
    let ageRestriction: Int?
    let siteURL: String?

    enum CodingKeys: String, CodingKey {
        case dates
        case title, description
        case shortPlace = "place"
        case shortTitle = "short_title"
        case bodyText = "body_text"
        case secondSubtitle
        case categories
        case ageRestriction = "age_restriction"
        case firstSubtitle = "price"
        case boolSubtitle = "is_free"
        case images
        case siteURL = "site_url"
    }
}



