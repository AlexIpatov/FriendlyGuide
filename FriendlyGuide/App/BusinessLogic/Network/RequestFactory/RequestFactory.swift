//
//  RequestFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

class RequestFactory {
    
    lazy var commonSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        let manager = URLSession(configuration: configuration,
                                 delegate: nil,
                                 delegateQueue: .main)
        return manager
    }()
    
    func makeGetCityNameFactory() -> GetCityNamesFactory {
        let encoder = URLPathParameterEncoder()
        return GetCityNames(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetCityDetailFactory() -> GetCityDetailFactory {
        let encoder = URLPathParameterEncoder()
        return GetCityDetail(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetEventsListFactory() -> GetEventsListFactory {
        let encoder = URLPathParameterEncoder()
        return GetEventsList(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetEventDetailFactory() -> GetEventDetailFactory {
        let encoder = URLPathParameterEncoder()
        return GetEventDetail(encoder: encoder,
                           sessionManager: commonSession)
    }
    
}
