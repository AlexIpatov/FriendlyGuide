//
//  AppMainViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import UIKit
import CoreLocation

final class AppMainViewControllerBuilder {
    private lazy var userSettings: UserSettings = {
        UserSettings()
    }()
    private lazy var travelDataProvider: TravelScreenDataProvider = {
        TravelScreenDataProvider()
    }()
    
    private let requestFactory: RequestFactory
    
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
    }
    
    func build() -> UIViewController {
        TabBarController(requestFactory: requestFactory,
                         userSettings: userSettings,
                         dataProvider: travelDataProvider)
    }
}
