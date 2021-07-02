//
//  Event.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct EventDetail: Codable, Hashable {
    
    private let title: String
    private let eventDescription: String?
    private let firstSubtitle: String?
    private let secondSubtitle: String?
    private let boolSubtitle: Bool?
    private  let images: [Image]?
    let shortPlace: EventPlace?
    private let bodyText: String?
    private let dates: [DateElement]
    private let siteURL: String?

    enum CodingKeys: String, CodingKey {
        case dates
        case title
        case eventDescription = "description"
        case shortPlace = "place"
        case bodyText = "body_text"
        case secondSubtitle
        case firstSubtitle = "price"
        case boolSubtitle = "is_free"
        case images
        case siteURL = "site_url"
    }
    
    init(title: String, eventDescription: String?, firstSubtitle: String?, secondSubtitle: String?,
         boolSubtitle: Bool?, images: [Image]?, shortPlace: EventPlace?, bodyText: String?,
         dates: [DateElement], siteURL: String?) {
        self.title = title
        self.eventDescription = eventDescription
        self.firstSubtitle = firstSubtitle
        self.secondSubtitle = secondSubtitle
        self.boolSubtitle = boolSubtitle
        self.images = images
        self.shortPlace = shortPlace
        self.bodyText = bodyText
        self.dates = dates
        self.siteURL = siteURL
    }
}

extension EventDetail: DetailScreenRepresentable {
    var detailEntity: DetailEntity {
        DetailEntity(images: images, bodyText: bodyText)
    }
        
    var description: DescriptionForEntity {
        DescriptionForEntity(title: title,
                             description: eventDescription,
                             firstSubtitle: firstSubtitle,
                             secondSubtitle: secondSubtitle,
                             boolSubtitle: boolSubtitle)
    }
}



