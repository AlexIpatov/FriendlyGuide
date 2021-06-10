//
//  GetPlaceDetailfactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import Foundation

protocol GetPlaceDetailFactory {
    func load(id: Int, completionHandler: @escaping (Result<PlaceDetail, NetworkingError>) -> Void)
}
