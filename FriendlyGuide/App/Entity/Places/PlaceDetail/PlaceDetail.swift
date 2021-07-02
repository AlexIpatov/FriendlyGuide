//
//  PlaceDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct PlaceDetail: Codable, Hashable {
    private let title: String
    private let placeDescription: String?
    private let firstSubtitle: String?
    private let boolSubtitle: Bool?
    private let images: [Image]?
    private let bodyText: String?
    private var secondSubtitle: String?
    
    private let address: String?
    private let phone: String?
    private let coords: Coordinates?
    private let subway: String?
    private let categories: [String]?
    private let siteUrl: String?

    enum CodingKeys: String, CodingKey {
        case title, address, phone
        case firstSubtitle = "timetable"
        case bodyText = "body_text"
        case siteUrl = "site_url"
        case placeDescription = "description"
        case coords, subway, images
        case boolSubtitle = "is_closed"
        case categories
    }
    
    init(title: String, placeDescription: String?, firstSubtitle: String?, boolSubtitle: Bool?,
         images: [Image]?, bodyText: String?, secondSubtitle: String?, address: String?, phone: String?,
         coords: Coordinates?, subway: String?, categories: [String]?, siteUrl: String?) {
        self.title = title
        self.placeDescription = placeDescription
        self.firstSubtitle = firstSubtitle
        self.boolSubtitle = boolSubtitle
        self.images = images
        self.bodyText = bodyText
        self.secondSubtitle = secondSubtitle
        self.address = address
        self.phone = phone
        self.coords = coords
        self.subway = subway
        self.categories = categories
        self.siteUrl = siteUrl
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
                   coords: coords)
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

