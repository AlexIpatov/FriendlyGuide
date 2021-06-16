//
//  GetEventsList.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

class GetEventsList {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetEventsList: AbstractRequestFactory {
    typealias EndPoint = EventsListResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetEventsList: GetEventsListFactory {
    func load(cityTag: String,
                       actualSince: String,
                       completionHandler: @escaping (Result<EndPoint.ModelType,
                                                            NetworkingError>) -> Void) {
        let route = EventsListResource(cityTag: cityTag, actualSince: actualSince)
        request(route, withCompletion: completionHandler)
    }
}
