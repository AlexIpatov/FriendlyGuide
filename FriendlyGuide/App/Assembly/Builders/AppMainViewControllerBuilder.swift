//
//  AppMainViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import UIKit
import CoreLocation

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
    private lazy var locationManager: LocationManager = {
        LocationManager.instance
    }()
    private lazy var selfieImage: UIImage? = {
        return UIImage(systemName: "figure.walk.circle")!
        //TO DO - Need selfie from user defaults
    }()
    
    func build() -> UIViewController {
        TabBarController(requestFactory: requestFactory,
                         userSettings: userSettings,
                         dataProvider: travelDataProvider,
                         locationManager: locationManager,
                         selfieImage: selfieImage)
    }
}
