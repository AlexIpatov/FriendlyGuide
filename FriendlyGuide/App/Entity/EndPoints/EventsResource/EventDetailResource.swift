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
        URLQueryItem(name: "lang", value: "ru"),
        URLQueryItem(name: "fields", value: "title,place,body_text,price,age_restriction,categories,dates,images,site_url,is_free,description,short_title"),
        URLQueryItem(name: "expand", value: "place"),
        URLQueryItem(name: "text_format", value: "text"),
    ]
    var parameters: Parameters {
        [ "eventID" : eventID]
    }
}
