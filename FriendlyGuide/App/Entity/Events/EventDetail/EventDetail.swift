//
//  Event.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventDetail: Codable, Hashable {
    
    let title: String
    let description: String?
    let firstSubtitle: String?
    let secondSubtitle: String?
    let boolSubtitle: Bool?
    let images: [Image]?
    let shortPlace: EventPlace?
    let bodyText: String?
    let dates: [DateElement]
    let siteURL: String?

    enum CodingKeys: String, CodingKey {
        case dates
        case title, description
        case shortPlace = "place"
        case bodyText = "body_text"
        case secondSubtitle
        case firstSubtitle = "price"
        case boolSubtitle = "is_free"
        case images
        case siteURL = "site_url"
    }
}

extension EventDetail: DetailScreenRepresentable {
    var detailEntity: DetailEntity {
        DetailEntity(images: images, bodyText: bodyText)
    }
        
    var descriptionForEntity: DescriptionForEntity {
        DescriptionForEntity(title: title,
                             description: description,
                             firstSubtitle: firstSubtitle,
                             secondSubtitle: secondSubtitle,
                             boolSubtitle: boolSubtitle)
    }
}



