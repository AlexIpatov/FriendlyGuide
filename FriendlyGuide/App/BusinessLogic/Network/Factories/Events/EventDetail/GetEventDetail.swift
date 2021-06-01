//
//  GetEventDetail.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 27.05.2021.
//

import Foundation

class GetEventDetail {
    let sessionManager: URLSession
    let encoder: ParameterEncoder
    init(
        encoder: ParameterEncoder,
        sessionManager: URLSession) {
        self.encoder = encoder
        self.sessionManager = sessionManager
    }
}

extension GetEventDetail: AbstractRequestFactory {
    typealias EndPoint = EventDetailResource
    func request(withCompletion completion:
                    @escaping (Result<EndPoint.ModelType, NetworkingError>) -> Void) {}
}

extension GetEventDetail: GetEventDetailFactory {
    func getEventDetail(eventID: Int, completionHandler: @escaping (Result<EndPoint.ModelType,
                                                            NetworkingError>) -> Void) {
        let route = EventDetailResource(eventID: eventID)
        request(route, withCompletion: completionHandler)
    }
}
