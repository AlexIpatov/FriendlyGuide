//
//  TravelRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation

protocol MapDataProvider {
    typealias MapScreenData = (events: [Event], places: [Place])
    func getData(cityTag: String,
                 actualSince: String,
                 showingSince: String,
                 withCompletion completion: @escaping (Result<MapScreenData, NetworkingError>) -> Void)
}
