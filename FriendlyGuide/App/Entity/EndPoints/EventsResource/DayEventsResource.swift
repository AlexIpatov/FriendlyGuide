//
//  File.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 28.05.2021.
//

import Foundation

struct DayEventsResource: EndPointType {
    typealias ModelType = DayEventsList
    var host: BaseURL = .kudago
    var path: Path = .eventsOfTheDay
    var httpMethod: HTTPMethod = .get
    var queryItems = [ URLQueryItem(name: "lang", value: "ru") ]
    var parameters: Parameters = [:]
}
