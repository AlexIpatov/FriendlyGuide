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
    
    var eventsLoadingCompleted = false
    var newsLoadingCompleted = false
    var placesLoadingCompleted = false
    
    init(requestFactory: RequestFactory = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
}

extension TravelDataProvider: DataProvider {
    
    func getData(cityTag: String) -> Void {
        let newsFactory = requestFactory.makeGetNewsFactory()
        let placesFactory = requestFactory.makeGetPlacesFactory()
        let eventsFactory = requestFactory.makeGetEventsListFactory()
        
        group.enter()
        queue.async {
            eventsFactory.getEventsList(cityTag: cityTag, actualSince: "1444385206") {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            //self.travelData?.events = response.results
                            print("EventsLoaded")
                            self.eventsLoadingCompleted = true
                            self.group.leave()
                        case.failure(let error):
                            print(error.localizedDescription)
                            self.group.leave()
                        }
                    }
        }
        group.enter()
        queue.async {
            placesFactory.getPlaces(cityTag: cityTag, showingSince: "1444385206") {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            //self.travelData?.events = response.results
                            print("PlacesLoaded")
                            self.placesLoadingCompleted = true
                            self.group.leave()
                        case.failure(let error):
                            print(error.localizedDescription)
                            self.group.leave()
                        }
                    }
        }
        group.enter()
        queue.async {
            newsFactory.getNews(cityTag: cityTag) {[weak self] response in
                        guard let self = self else { return }
                        switch response {
                        case.success(let response):
                            //self.travelData?.events = response.results
                            print("NewsLoaded")
                            self.placesLoadingCompleted = true
                            self.group.leave()
                        case.failure(let error):
                            print(error.localizedDescription)
                            self.group.leave()
                        }
                    }
        }
        
        group.notify(queue: queue) {
            
            print("All operations completed. \(self.eventsLoadingCompleted), \(self.placesLoadingCompleted), \(self.newsLoadingCompleted)")
                }
        
    }
        
}

