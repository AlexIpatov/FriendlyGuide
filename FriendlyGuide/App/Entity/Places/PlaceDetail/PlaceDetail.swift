//
//  PlaceDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct PlaceDetail: Codable, Hashable {
    let id: Int
    let title, slug, address, timetable: String
    let phone: String
    let isStub: Bool
    let bodyText, placesListDescription: String
    let siteURL: String
    let foreignURL: String
    let coords: Coordinates
    let subway: String
    let favoritesCount: Int
    let images: [PlaceImage]
    let commentsCount: Int
    let isClosed: Bool
    let categories: [String]
    let shortTitle: String
    let tags: [String]
    let location: String
    let ageRestriction: Int
    let disableComments, hasParkingLot: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, slug, address, timetable, phone
        case isStub = "is_stub"
        case bodyText = "body_text"
        case placesListDescription = "description"
        case siteURL = "site_url"
        case foreignURL = "foreign_url"
        case coords, subway
        case favoritesCount = "favorites_count"
        case images
        case commentsCount = "comments_count"
        case isClosed = "is_closed"
        case categories
        case shortTitle = "short_title"
        case tags, location
        case ageRestriction = "age_restriction"
        case disableComments = "disable_comments"
        case hasParkingLot = "has_parking_lot"
    }
}
