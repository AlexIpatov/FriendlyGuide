//
//  GetPlacesFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 01.06.2021.
//

import Foundation

protocol GetPlacesFactory {
    func getPlaces(cityTag: String,
                   showingSince: String,
                   completionHandler: @escaping (Result<PlacesList, NetworkingError>) -> Void)
}
