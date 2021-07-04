//
//  TravelDataProvider.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation

protocol TravelDataProvider {
    typealias TravelData = (events: [Event], news: [News], places: [Place])
    func getData(cityTag: String,
                 actualSince: String,
                 showingSince: String,
                 withCompletion completion: @escaping (Result<TravelData, NetworkingError>) -> Void)
}
