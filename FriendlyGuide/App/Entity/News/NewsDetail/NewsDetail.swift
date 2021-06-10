//
//  NewsDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation
//struct NewsPlace и NewsImage будут удалены и заменены полями NewsDetail
struct NewsDetail: Codable, Hashable {
    let id, publicationDate: Int
    let title, slug: String
    let place: NewsPlace?
    let newsDescription, bodyText: String
    let images: [NewsImage]
    let siteURL: String
    let favoritesCount, commentsCount: Int

    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case title, slug, place
        case newsDescription = "description"
        case bodyText = "body_text"
        case images
        case siteURL = "site_url"
        case favoritesCount = "favorites_count"
        case commentsCount = "comments_count"
    }
}
