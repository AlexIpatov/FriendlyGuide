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
    private var travelData: TravelData?
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
                            self.group.leave()
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
        }
        group.enter()
        queue.async {
            placesFactory.load(cityTag: cityTag, showingSince: showingSince) {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            places = response.places
                            self.group.leave()
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
        }
        group.enter()
        queue.async {
            newsFactory.load(cityTag: cityTag) {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            news = response.news
                            self.group.leave()
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
        }
        
        group.notify(queue: queue) {
                completion(.success((events, news, places)))
    }
}

}