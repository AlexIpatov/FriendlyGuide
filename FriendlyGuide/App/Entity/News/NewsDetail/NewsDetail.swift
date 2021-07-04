//
//  NewsDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct NewsDetail: Codable, Hashable {
    
    let title: String
    let newsDescription: String?
    let bodyText: String?
    let images: [Image]?
    var firstSubtitle: String?
    var boolSubtitle: Bool?
    let publicationDate: Date
    let siteURL: String
    let shortPlace: EventPlace?
    var secondSubtitle: String? {
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
