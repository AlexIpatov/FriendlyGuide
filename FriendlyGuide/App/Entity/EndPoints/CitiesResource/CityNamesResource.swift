//
//  CityNames.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

struct CityNamesResource: EndPointType {
    typealias ModelType = [CityName]
    var host: BaseURL = .kudago
    var path: Path = .cities
    var httpMethod: HTTPMethod = .get
    var queryItems = [
    URLQueryItem(name: "lang", value: "ru")
    ]
    var parameters: Parameters = [:]
}
