//
//  TravelRepository.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 31.05.2021.
//

import Foundation

protocol DataProvider {
    func getData(cityID: Int) -> [Event]
}
