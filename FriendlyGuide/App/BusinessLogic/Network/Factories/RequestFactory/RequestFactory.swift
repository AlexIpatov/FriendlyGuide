//
//  RequestFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

class RequestFactory {
    
    private let commonSession: URLSession
    
    init(commonSession: URLSession = URLSession.shared) {
        self.commonSession = commonSession
    }
    
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
    
    func makeGetNewsFactory() -> GetNewsFactory {
        let encoder = URLPathParameterEncoder()
        return GetNews(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetPlacesFactory() -> GetPlacesFactory {
        let encoder = URLPathParameterEncoder()
        return GetPlaces(encoder: encoder,
                           sessionManager: commonSession)
    }
    
}
