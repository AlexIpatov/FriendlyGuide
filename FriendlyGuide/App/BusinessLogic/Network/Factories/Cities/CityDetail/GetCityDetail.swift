//
//  GetCityDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

class GetCityDetail {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetCityDetail: AbstractRequestFactory {
    typealias EndPoint = CityDetailResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetCityDetail: GetCityDetailFactory {
    func load(cityTag: String,
                      completionHandler: @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {
        let route = CityDetailResource(cityTag: cityTag)
        request(route, withCompletion: completionHandler)
    }
}
