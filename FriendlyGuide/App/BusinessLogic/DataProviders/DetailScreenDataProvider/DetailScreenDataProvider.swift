//
//  DetailScreenDataProvider.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 21.06.2021.
//

import Foundation

protocol DetailScreenRepresentable {
//        var title: String { get }
//        var description: String? { get }
//        var firstSubtitle: String? { get }
//        var secondSubtitle: String? { get }
//        var boolSubtitle: Bool? { get }
//        var images: [Image]? { get }
//        var bodyText: String? { get }
    var shortPlace: EventPlace? { get }
    var detailEntity : DetailEntity { get }
    var descriptionForEntity: DescriptionForEntity { get }
}

protocol DetailDataProvider {
    func getData(by id: Int,
                 with modelType: TravelSection,
                 with completion: @escaping (Result<DetailScreenRepresentable, NetworkingError>) -> Void)
}


class DetailScreenDataProvider: DetailDataProvider {
    
    func getData(by id: Int,
                 with modelType: TravelSection,
                 with completion: @escaping (Result<DetailScreenRepresentable, NetworkingError>) -> Void) {
        let requestFactory = RequestFactory()
        
        switch modelType {
        case .events:
            let eventRequest = requestFactory.makeGetEventDetailFactory()
            eventRequest.load(eventID: id) { response in
                switch response {
                case .success(let eventDetail):
                    completion(.success(eventDetail))
                case.failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .news:
            let newsRequest = requestFactory.makeGetNewsDetailFactory()
            newsRequest.load(id: id) { response in
                switch response {
                case .success(let newsDetail):
                    completion(.success(newsDetail))
                case.failure(let error):
                    completion(.failure(error))
                }
            }
            
        case .places:
            let placeRequest = requestFactory.makeGetPlaceDetailFactory()
            placeRequest.load(id: id) { response in
                switch response {
                case .success(let placeDetail):
                   completion(.success(placeDetail))
                case.failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
