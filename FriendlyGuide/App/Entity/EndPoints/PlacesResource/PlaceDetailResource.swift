//
//  PlaceDetailResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import Foundation

struct PlaceDetailResource: EndPointType {
    typealias ModelType = PlaceDetail
    var host: BaseURL = .kudago
    var path: Path = .places
    var httpMethod: HTTPMethod = .get
    var id: Int
    var parameters: Parameters {
        [ "path" : id ]
    }
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "lang", value: "ru"),
        ]
    }
    
}
