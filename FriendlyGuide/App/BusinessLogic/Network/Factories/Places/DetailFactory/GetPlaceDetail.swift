//
//  GetPlaceDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import Foundation

class GetPlaceDetail {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetPlaceDetail: AbstractRequestFactory {
    typealias EndPoint = PlaceDetailResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetPlaceDetail: GetPlaceDetailFactory {
    func load(id: Int, completionHandler: @escaping (Result<EndPoint.ModelType,
                                                        NetworkingError>) -> Void) {
        let route = PlaceDetailResource(id: id)
        request(route, withCompletion: completionHandler)
    }
}
