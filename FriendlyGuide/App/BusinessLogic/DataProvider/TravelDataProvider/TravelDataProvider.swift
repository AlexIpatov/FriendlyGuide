//
//  TravelDataRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation
import Kingfisher

class TravelDataProvider{
    
    private let requestFactory: RequestFactory
    private var travelData: TravelData?
    private let queue = DispatchQueue(label: "Serial queue")
    private let group = DispatchGroup()
    
    private var eventsLoadingCompleted = false
    private var newsLoadingCompleted = false
    private var placesLoadingCompleted = false
    
    init(requestFactory: RequestFactory = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
}

extension TravelDataProvider: DataProvider {
    
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
            eventsFactory.getEventsList(cityTag: cityTag, actualSince: actualSince) {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            events = response.results
                            self.eventsLoadingCompleted = true
                            self.group.leave()
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
        }
        group.enter()
        queue.async {
            placesFactory.getPlaces(cityTag: cityTag, showingSince: showingSince) {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            places = response.places
                            self.placesLoadingCompleted = true
                            self.group.leave()
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
        }
        group.enter()
        queue.async {
            newsFactory.getNews(cityTag: cityTag) {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            news = response.news
                            self.newsLoadingCompleted = true
                            self.group.leave()
                        case.failure(let error):
                            completion(.failure(error))
                        }
                    }
        }
        
        group.notify(queue: queue) {
            if self.eventsLoadingCompleted && self.newsLoadingCompleted && self.placesLoadingCompleted {
                completion(.success((events, news, places)))
            } else {
                completion(.failure(NetworkingError.invalidRequest))
            }
    }
}

}
//let dp = TravelDataProvider()
//dp.getData(cityTag: "spb",
//           actualSince: "1444385206",
//           showingSince: "1444385206") { [weak self] response in
//    switch response {
//    case .success(let data):
//        let events = data.events
//        events.forEach { print($0.title) }
//    case .failure(let error):
//        print(error.localizedDescription)
//    }
//}
