//
//  CityResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

struct CityDetailResource: EndPointType {
    typealias ModelType = CityDetail
    var host: BaseURL = .kudago
    var path: Path = .cities
    var httpMethod: HTTPMethod = .get
    var cityTag: String
    var queryItems = [ URLQueryItem(name: "lang", value: "ru") ]
    var parameters: Parameters {
        [ "cityTag" : cityTag ]
    }
}
