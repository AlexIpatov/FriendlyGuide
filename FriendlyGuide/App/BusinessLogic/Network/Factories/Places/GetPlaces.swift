//
//  GetPlaces.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 01.06.2021.
//

import Foundation

class GetPlaces {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetPlaces: AbstractRequestFactory {
    typealias EndPoint = PlacesListResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetPlaces: GetPlacesFactory {
    func getPlaces(cityTag: String,
                   showingSince: String,
                   completionHandler: @escaping (Result<EndPoint.ModelType,
                                                        NetworkingError>) -> Void) {
        let route = PlacesListResource(cityTag: cityTag, showingSince: showingSince)
        request(route, withCompletion: completionHandler)
    }
}
