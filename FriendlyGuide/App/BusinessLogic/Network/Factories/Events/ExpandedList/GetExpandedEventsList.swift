//
//  ExpandedEventsList.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation

class GetExpandedEventsList {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetExpandedEventsList: AbstractRequestFactory {
    typealias EndPoint = ExpEventsListResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetExpandedEventsList: GetExpandedEventsListFactory {
    func load(cityTag: String,
              actualSince: String,
              completionHandler: @escaping (Result<EndPoint.ModelType,
                                                   NetworkingError>) -> Void) {
        let route = ExpEventsListResource(cityTag: cityTag, actualSince: actualSince)
        request(route, withCompletion: completionHandler)
    }
}
