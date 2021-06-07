//
//  PlacesList.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct PlacesList: Codable, Hashable {
    let count: Int
    let next: String?
    let previous: String?
    let places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case places = "results"
    }
}
