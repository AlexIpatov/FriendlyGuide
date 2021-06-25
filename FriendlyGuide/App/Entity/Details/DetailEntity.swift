//
//  Detail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 23.06.2021.
//

import Foundation


struct DetailEntity: Hashable, Codable {
    var images: [Image]?
    var bodyText: String?
    
    enum CodingKeys: String, CodingKey {
        case bodyText = "body_text"
        case images
    }
}

