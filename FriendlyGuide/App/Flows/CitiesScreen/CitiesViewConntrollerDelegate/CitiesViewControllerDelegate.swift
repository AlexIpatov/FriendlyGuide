//
//  CitiesViewControllerDelegate.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import Foundation

protocol CitiesViewControllerDelegate: AnyObject {
    func selectCity(city: CityName)
}
