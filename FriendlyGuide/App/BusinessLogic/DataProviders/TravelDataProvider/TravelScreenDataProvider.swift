//
//  TravelDataRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation
import Kingfisher

class TravelScreenDataProvider{
    
    private let requestFactory: RequestFactory
    private let queue = DispatchQueue(label: "Serial queue")
    private let group = DispatchGroup()
    
    init(requestFactory: RequestFactory = .init()) {
        self.requestFactory = requestFactory
    }
}

extension TravelScreenDataProvider: DataProvider {
    
    func getData(cityTag: String,
                 actualSince: String,
                 showingSince: String,
                 withCompletion completion: @escaping (Result<TravelData, NetworkingError>) -> Void) {
        let newsFactory = requestFactory.makeGetNewsFactory()
        let placesFactory = requestFactory.makeGetPlacesFactory()
        let eventsFactory = requestFactory.makeGetEventsListFactory()
        var events = [Event]()
        var news = [News]()
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
        group.enter()
        queue.async {
            newsFactory.load(cityTag: cityTag) {[weak self] response in
                guard let self = self else { return }
                switch response {
                case.success(let response):
                    news = response.news
                case.failure(let error):
                    completion(.failure(error))
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: queue) {
            if !events.isEmpty && !news.isEmpty && !places.isEmpty {
                completion(.success((events, news, places)))
            } else {
                completion(.failure(NetworkingError.requestFailed))
            }
        }
    }
    
}
