//
//  EventDetailResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

struct EventDetailResource: EndPointType {
    typealias ModelType = EventDetail
    var host: BaseURL = .kudago
    var path: Path = .events
    var httpMethod: HTTPMethod = .get
    var eventID: Int
    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "lang", value: "ru")
    ]
    var parameters: Parameters {
        [ "eventID" : eventID ]
    }
}
