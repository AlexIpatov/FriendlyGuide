//
//  Places.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct Places: Codable, Hashable {
    let id: Int
    let title: String
    let address: String?
    let coords: Coordinates
    let subway: String
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case id, title, images, address, subway, coords
    }
}

