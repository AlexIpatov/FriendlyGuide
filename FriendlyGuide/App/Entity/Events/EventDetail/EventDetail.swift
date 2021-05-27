//
//  Event.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventDetail: Codable, Hashable {
    let id: Int
    let publicationDate: Int
    let dates: [DateElement]
    let title: String
    let slug: String
    let place: EventPlace
    let eventDescription: String
    let bodyText: String
    let location: EventLocation
    let categories: [String]
    let tagline: String
    let price: String
    let ageRestriction: String
    let isFree: Bool
    let images: [Image]
    let favoritesCount: Int
    let commentsCount: Int
    let siteURL: String
    let shortTitle: String
    let tags: [String]
    let disableComments: Bool
    let participants: [EventParticipant]

    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case dates, title, slug, place
        case eventDescription = "description"
        case bodyText = "body_text"
        case location, categories, tagline
        case ageRestriction = "age_restriction"
        case price
        case isFree = "is_free"
        case images
        case favoritesCount = "favorites_count"
        case commentsCount = "comments_count"
        case siteURL = "site_url"
        case shortTitle = "short_title"
        case tags
        case disableComments = "disable_comments"
        case participants
    }
}



