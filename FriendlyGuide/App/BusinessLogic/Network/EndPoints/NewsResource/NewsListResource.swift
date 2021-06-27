//
//  NewsResource.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 01.06.2021.
//

import Foundation

struct NewsListResource: EndPointType {
    typealias ModelType = NewsList
    var host: BaseURL = .kudago
    var path: Path = .news
    var httpMethod: HTTPMethod = .get
    var cityTag: String
    var parameters: Parameters = [:]
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "lang", value: "ru"),
            URLQueryItem(name: "location", value: cityTag),
            URLQueryItem(name: "actual_only", value: "true"),
            URLQueryItem(name: "fields", value: "id,publication_date,title,description,images"),
            URLQueryItem(name: "text_format", value: "text"),
        ]
    }
}
