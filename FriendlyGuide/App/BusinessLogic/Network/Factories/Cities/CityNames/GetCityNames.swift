//
//  GetCityNames.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

class GetCityNames {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetCityNames: AbstractRequestFactory {
    typealias EndPoint = CityNamesResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetCityNames: GetCityNamesFactory {
    func load(completionHandler: @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {
        let route = CityNamesResource()
        request(route, withCompletion: completionHandler)
    }

}
