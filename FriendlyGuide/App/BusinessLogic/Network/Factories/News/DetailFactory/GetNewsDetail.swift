//
//  GetNewsDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import Foundation

class GetNewsDetail {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetNewsDetail: AbstractRequestFactory {
    typealias EndPoint = NewsDetailResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetNewsDetail: GetNewsDetailFactory {
    func load(id: Int, completionHandler: @escaping (Result<EndPoint.ModelType,
                                                        NetworkingError>) -> Void) {
        let route = NewsDetailResource(id: id)
        request(route, withCompletion: completionHandler)
    }
}
