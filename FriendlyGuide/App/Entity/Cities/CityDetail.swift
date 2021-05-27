//
//  City.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

struct CityDetail: Codable, Hashable {
    let slug    : String
    let name    : String
    let timezone: String
    let coords  : Coordinates
    let language: String
    let currency: String
}
