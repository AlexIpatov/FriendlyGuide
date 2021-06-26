//
//  NewsDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct NewsDetail: Codable, Hashable {
    
    private let title: String
    private let newsDescription: String?
    private let bodyText: String?
    private let images: [Image]?
    private var firstSubtitle: String?
    private var boolSubtitle: Bool?
    private let publicationDate: Date
    private let siteURL: String
    let shortPlace: EventPlace?
    private var secondSubtitle: String? {
        return publicationDate.goToSimpleDate()
    }
    
    enum CodingKeys: String, CodingKey {
        case publicationDate = "publication_date"
        case title
        case shortPlace = "place"
        case newsDescription = "description"
        case bodyText = "body_text"
        case images
        case siteURL = "site_url"
    }
    
}

extension NewsDetail: DetailScreenRepresentable {
    
    var detailEntity: DetailEntity {
        DetailEntity(images: images, bodyText: bodyText)
    }
    
    var description: DescriptionForEntity {
        DescriptionForEntity(title: title,
                             description: newsDescription,
                             firstSubtitle: firstSubtitle,
                             secondSubtitle: secondSubtitle,
                             boolSubtitle: boolSubtitle)
    }
}
