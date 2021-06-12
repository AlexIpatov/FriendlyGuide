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
            URLQueryItem(name: "fields", value: "title,body_text,coords,phone,address,timetable,subway,coords,description,images,categories,is_closed,site_url"),
            URLQueryItem(name: "expand", value: "place"),
            URLQueryItem(name: "text_format", value: "text"),
        ]
    }
    
}
