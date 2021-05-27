//
//  GetCityNamesFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

protocol GetCityNamesFactory {
    func getCityNames( completionHandler: @escaping (Result<[CityName], NetworkingError>) -> Void)
}
