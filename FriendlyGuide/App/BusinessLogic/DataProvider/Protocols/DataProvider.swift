//
//  TravelRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation

protocol DataProvider {
    typealias TravelData = (events: [Event], news: [News], places: [Places])
    func getData(cityTag: String) -> Void
}
