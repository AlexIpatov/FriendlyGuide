//
//  LocationManager.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 08.06.2021.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa


final class LocationManager: NSObject {
    //MARK: - Properties
    static let instance = LocationManager()
    
    private let locationManager = CLLocationManager()
    var currentLocation: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)
    
    // MARK: - Init
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    //MARK: - Configuration Methods
    private func configureLocationManager() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - Methods
    func startUpdatingLocationInLocationManager() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocationInLocationManager() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocationInLocationManager() {
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation.accept(location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
