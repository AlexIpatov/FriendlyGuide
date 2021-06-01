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
    func getEventsList(completionHandler: @escaping (Result<EndPoint.ModelType,
                                                            NetworkingError>) -> Void) {
        let route = EventsListResource()
        request(route, withCompletion: completionHandler)
    }
}
