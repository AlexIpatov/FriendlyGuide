//
//  PlacesResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 01.06.2021.
//

import Foundation

struct PlacesListResource: EndPointType {
    typealias ModelType = PlacesList
    var host: BaseURL = .kudago
    var path: Path = .places
    var httpMethod: HTTPMethod = .get
    var cityTag: String
    var showingSince: String
    var parameters: Parameters = [:]
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "location", value: cityTag),
            URLQueryItem(name: "showing_since", value: showingSince),
            URLQueryItem(name: "fields", value: "id,title,coords,address,images,subway")
        ]
    }
}
