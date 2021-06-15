//
//  NewsDetailResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import Foundation

struct NewsDetailResource: EndPointType {
    typealias ModelType = NewsDetail
    var host: BaseURL = .kudago
    var path: Path = .news
    var httpMethod: HTTPMethod = .get
    var id: Int
    var parameters: Parameters {
        [ "path" : id ]
    }
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "expand", value: "place"),
            URLQueryItem(name: "text_format", value: "text"),
            URLQueryItem(name: "fields", value: "publication_date,title,description,images,site_url,place,body_text"),
        ]
    }
    
}
