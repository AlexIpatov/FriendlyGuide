//
//  GetCityDetailFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 26.05.2021.
//

import Foundation

protocol GetCityDetailFactory {
    func getCityDetail(cityTag: String,
                       completionHandler: @escaping (Result<CityDetail, NetworkingError>) -> Void)
}
