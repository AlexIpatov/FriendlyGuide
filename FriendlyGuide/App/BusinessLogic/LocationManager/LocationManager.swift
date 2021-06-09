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
    var location: BehaviorRelay<CLLocation?> = BehaviorRelay(value: nil)

    // MARK: - Init
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    //MARK: - Configuration Methods
    private func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
    }
    
    //MARK: - Methods
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location.accept(locations.last)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
