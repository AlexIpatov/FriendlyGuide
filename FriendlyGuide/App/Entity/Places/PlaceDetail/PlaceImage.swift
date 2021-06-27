//
//  PlaceImage.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct PlaceImage: Codable, Hashable {
    let image: String
    let source: Source
}

// MARK: - Source
struct Source: Codable, Hashable {
    let link: String
    let name: String
}

