//
//  News.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct News: Codable, Hashable {
    let id: Int
    let publicationDate: Int
    let title: String
    let slug: String

    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case title, slug
    }
}
