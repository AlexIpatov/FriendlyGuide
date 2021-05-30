//
//  EventsListResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation
// TODO Добавить возможность выбрать локацию и добавить текущую дату 
struct EventsListResource: EndPointType {
    typealias ModelType = EventsList
    var host: BaseURL = .kudago
    var path: Path = .events
    var httpMethod: HTTPMethod = .get
    var parameters: Parameters = [:]
    var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "lang", value: "ru"),
        URLQueryItem(name: "fields", value: "id,title,images,dates")
    ]
}
