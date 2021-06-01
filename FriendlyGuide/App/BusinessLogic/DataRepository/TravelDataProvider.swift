//
//  TravelDataRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation
import Kingfisher

class TravelDataProvider{
    
    let requestFactory: RequestFactory
    private var travelData: TravelData?
    private let queue = DispatchQueue(label: "Serial queue")
    private let group = DispatchGroup()
    
    init(requestFactory: RequestFactory = RequestFactory()) {
        self.requestFactory = requestFactory
    }
    
    fileprivate func getEvents(cityTag: String, actualSince: String) {
        let loader = requestFactory.makeGetEventsListFactory()
        loader.getEventsList(cityTag: cityTag, actualSince: actualSince) {[weak self] response in
            guard let self = self else { return }
            switch response {
            case.success(let response):
                self.travelData?.events = response.results
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func getNews(cityTag: String) {
        let loader = requestFactory.makeGetNewsFactory()
        loader.getNews(cityTag: cityTag) {[weak self] response in
            guard let self = self else { return }
            switch response {
            case.success(let response):
                self.travelData?.news = response.news
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    fileprivate func getPlaces(cityTag: String) {
        let loader = requestFactory.makeGetPlacesFactory()
        loader.getPlaces(cityTag: cityTag, showingSince: "1444385206") {[weak self] response in
            guard let self = self else { return }
            switch response {
            case.success(let response):
                self.travelData?.places = response.places
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension TravelDataProvider: DataProvider {
    
    func getData(cityTag: String) -> Void {
        group.enter()
        queue.async {
            self.getEvents(cityTag: cityTag, actualSince: "1444385206")
            self.group.leave()
        }

        group.enter()
        queue.async {
            self.getNews(cityTag: cityTag)
            self.group.leave()
        }

        group.notify(queue: queue) {
            print(self.travelData?.events.first as Any)
        }
    }
    
   
    
}

