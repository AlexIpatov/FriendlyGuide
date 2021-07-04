//
//  MapScreenDataProvier.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation

class MapScreenDataProvider{
    
    private let requestFactory: RequestFactory
    private let queue = DispatchQueue(label: "Serial queue")
    private let group = DispatchGroup()
    
    init(requestFactory: RequestFactory = .init()) {
        self.requestFactory = requestFactory
    }
}

extension MapScreenDataProvider: MapDataProvider {
    
    func getData(cityTag: String,
                 actualSince: String,
                 showingSince: String,
                 withCompletion completion: @escaping (Result<MapScreenData, NetworkingError>) -> Void) {
        let placesFactory = requestFactory.makeGetPlacesFactory()
        let eventsFactory = requestFactory.makeGetExpEventsListFactory()
        var events = [Event]()
        var places = [Place]()
        
        group.enter()
        queue.async {
            eventsFactory.load(cityTag: cityTag, actualSince: actualSince) {[weak self] response in
                guard let self = self else { return }
                switch response {
                case.success(let response):
                    events = response.results
                case.failure(let error):
                    completion(.failure(error))
                }
                self.group.leave()
            }
        }
        group.enter()
        queue.async {
            placesFactory.load(cityTag: cityTag, showingSince: showingSince) {[weak self] response in
                guard let self = self else { return }
                switch response {
                case.success(let response):
                    places = response.places
                case.failure(let error):
                    completion(.failure(error))
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: queue) {
            if !events.isEmpty && !places.isEmpty {
                completion(.success((events, places)))
            } else {
                completion(.failure(NetworkingError.requestFailed))
            }
        }
    }
    
}
