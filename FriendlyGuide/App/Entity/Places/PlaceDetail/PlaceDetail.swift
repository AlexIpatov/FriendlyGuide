//
//  PlaceDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct PlaceDetail: Codable, Hashable {
    let title: String
    let placeDescription: String?
    let firstSubtitle: String?
    let boolSubtitle: Bool?
    let images: [Image]?
    let bodyText: String?
    var secondSubtitle: String?
    
    let address: String?
    let phone: String?
    let coords: Coordinates?
    let subway: String?
    let categories: [String]?
    let siteUrl: String?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case title, address, phone
        case firstSubtitle = "timetable"
        case bodyText = "body_text"
        case siteUrl = "site_url"
        case placeDescription = "description"
        case coords, subway, images
        case boolSubtitle = "is_closed"
        case categories
        case location
    }
    
}

extension PlaceDetail: DetailScreenRepresentable {
    var shortPlace: EventPlace? {
        EventPlace(title: title,
                   address: address,
                   phone: phone,
                   subway: subway,
                   siteURL: siteUrl,
                   isClosed: boolSubtitle,
                   coords: coords,
                   location: location)
    }
    
    var detailEntity: DetailEntity {
        DetailEntity(images: images, bodyText: bodyText)
    }
    
    var description: DescriptionForEntity {
        DescriptionForEntity(title: title,
                             description: placeDescription,
                             firstSubtitle: firstSubtitle,
                             secondSubtitle: secondSubtitle,
                             boolSubtitle: boolSubtitle)
    }
}

