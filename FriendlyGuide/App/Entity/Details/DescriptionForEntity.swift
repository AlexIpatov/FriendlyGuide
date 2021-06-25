//
//  DescriptionForEntity.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 23.06.2021.
//

import Foundation

struct DescriptionForEntity: Hashable, Codable {
    var title: String?
    var description: String?
    var firstSubtitle: String?
    var secondSubtitle: String?
    var boolSubtitle: Bool?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case secondSubtitle
        case firstSubtitle = "price"
        case boolSubtitle = "is_free"
    }
}
