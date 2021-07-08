//
//  Place.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct Place: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let address: String?
    let coords: Coordinates?
    let subway: String?
    let images: [Image]?
    let location: String?

    enum CodingKeys: String, CodingKey {
        case id, title, images, address, subway, coords, location
    }
}

