//
//  EventsListResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct EventsListResource: EndPointType {
    typealias ModelType = EventsList
    var host: BaseURL = .kudago
    var path: Path = .events
    var httpMethod: HTTPMethod = .get
    var cityTag: String
    var actualSince: String
    var parameters: Parameters = [:]
    var queryItems: [URLQueryItem] {
        [
        URLQueryItem(name: "lang", value: "ru"),
        URLQueryItem(name: "location", value: cityTag),
        URLQueryItem(name: "actual_since", value: actualSince),
        URLQueryItem(name: "fields", value: "id,title,images,dates")
    ]
    }
}
