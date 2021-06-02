//
//  AppMainViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import UIKit

final class AppMainViewControllerBuilder {
    private lazy var requestFactory: RequestFactory = {
        RequestFactory()
    }()
    private lazy var userSettings: UserSettings = {
        UserSettings()
    }()
    private lazy var travelDataProvider: TravelDataProvider = {
        TravelDataProvider()
    }()
    
    func build() -> UIViewController {
        TabBarController(requestFactory: requestFactory,
                         userSettings: userSettings,
                         dataProvider: travelDataProvider)
    }
}
