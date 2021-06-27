//
//  News.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct News: Codable, Hashable, Identifiable {
    let id: Int
    let publicationDate: Int
    let title: String
    let images: [Image]
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case title, images, description
    }
}
