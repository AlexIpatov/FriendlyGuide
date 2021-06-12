//
//  NewsDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation
//struct NewsPlace и NewsImage будут удалены и заменены полями NewsDetail
struct NewsDetail: Codable, Hashable {
    let publicationDate: Date
    let title: String
    let place: EventPlace?
    let description, bodyText: String?
    let images: [Image]
    let siteURL: String

    enum CodingKeys: String, CodingKey {
        case publicationDate = "publication_date"
        case title, place
        case description = "description"
        case bodyText = "body_text"
        case images
        case siteURL = "site_url"
    }
}
