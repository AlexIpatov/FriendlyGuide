//
//  GetNews.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 01.06.2021.
//

import Foundation

class GetNews {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetNews: AbstractRequestFactory {
    typealias EndPoint = NewsListResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetNews: GetNewsFactory {
    func getNews(cityTag: String,
                 completionHandler: @escaping (Result<EndPoint.ModelType,
                                                      NetworkingError>) -> Void) {
        let route = NewsListResource(cityTag: cityTag)
        request(route, withCompletion: completionHandler)
    }
}
