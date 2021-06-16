//
//  MapScreenView.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import MapKit

class MapScreenView: UIView {
    private(set) lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private(set) lazy var latitudeLabel = UILabel(text: "Latitude:",
                                             font: .smallTitleFont(),
                                             textColor: .black,
                                             numberOfLines: 1,
                                             textAlignment: .left,
                                             adjustsFontSizeToFitWidth: false)
    
    private(set) lazy var longitudeLabel = UILabel(text: "Longitude:",
                                             font: .smallTitleFont(),
                                             textColor: .black,
                                             numberOfLines: 1,
                                             textAlignment: .left,
                                             adjustsFontSizeToFitWidth: false)
    
    private(set) lazy var latitudeValueLabel = UILabel(text: "-00.0000",
                                             font: .smallTitleFont(),
                                             textColor: .black,
                                             numberOfLines: 1,
                                             textAlignment: .left,
                                             adjustsFontSizeToFitWidth: false)
    
    private(set) lazy var longitudeValueLabel = UILabel(text: "-00.0000",
                                             font: .smallTitleFont(),
                                             textColor: .black,
                                             numberOfLines: 1,
                                             textAlignment: .left,
                                             adjustsFontSizeToFitWidth: false)
    
    private(set) lazy var transitionToSettingsButton = UIButton(title: "Настройка геолокации",
                                                                font: .bigButtonFont(),
                                                                cornerRadius: 8.0,
                                                                backgroundColor: .systemGray5,
                                                                tintColor: .black)
    
    private(set) lazy var informationLabel = UILabel(
        text: "Службы геолокации отключены. Перейдите в настройки телефона для настройки служб геолокации и перезапустите приложение.",
        font: .smallTitleFont(),
        textColor: .black,
        numberOfLines: 0,
        textAlignment: .left,
        adjustsFontSizeToFitWidth: false)
    
    private(set) lazy var findPlaceOrEventButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "magnifyingglass.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "magnifyingglass.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    private(set) lazy var buildingRouteButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "arrow.triangle.turn.up.right.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    private(set) lazy var clearRouteButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "xmark.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "xmark.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    private(set) lazy var zoomInMapButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "plus.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "plus.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    private(set) lazy var zoomOutMapButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "minus.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "minus.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    private(set) lazy var startTrackingLocationButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "figure.walk.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "figure.walk.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    private(set) lazy var showCurrentLocationButton = UIButton(
        backgroundImageForNormalState: UIImage(systemName: "location.circle"),
        backgroundImageForHighlightedState: UIImage(systemName: "location.circle.fill"),
        cornerRadius: 20.0,
        backgroundColor: .white,
        tintColor: .systemBlue)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        startTrackingLocationButton.tag = 0
        
        self.addSubview(mapView)
        mapView.addSubview(latitudeLabel)
        mapView.addSubview(longitudeLabel)
        mapView.addSubview(latitudeValueLabel)
        mapView.addSubview(longitudeValueLabel)
        mapView.addSubview(transitionToSettingsButton)
        mapView.addSubview(informationLabel)
        mapView.addSubview(findPlaceOrEventButton)
        mapView.addSubview(buildingRouteButton)
        mapView.addSubview(clearRouteButton)
        mapView.addSubview(zoomInMapButton)
        mapView.addSubview(zoomOutMapButton)
        mapView.addSubview(startTrackingLocationButton)
        mapView.addSubview(showCurrentLocationButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            
            latitudeLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15.0),
            latitudeLabel.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15.0),
            latitudeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            latitudeLabel.widthAnchor.constraint(equalToConstant: 80.0),
            
            latitudeValueLabel.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15.0),
            latitudeValueLabel.leftAnchor.constraint(equalTo: latitudeLabel.rightAnchor, constant: 5.0),
            latitudeValueLabel.heightAnchor.constraint(equalToConstant: 20.0),
            latitudeValueLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            longitudeLabel.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 0.0),
            longitudeLabel.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15.0),
            longitudeLabel.heightAnchor.constraint(equalToConstant: 20.0),
            longitudeLabel.widthAnchor.constraint(equalToConstant: 80.0),
            
            longitudeValueLabel.topAnchor.constraint(equalTo: latitudeValueLabel.bottomAnchor, constant: 0.0),
            longitudeValueLabel.leftAnchor.constraint(equalTo: longitudeLabel.rightAnchor, constant: 5.0),
            longitudeValueLabel.heightAnchor.constraint(equalToConstant: 20.0),
            longitudeValueLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            transitionToSettingsButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15.0),
            transitionToSettingsButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 15.0),
            transitionToSettingsButton.heightAnchor.constraint(equalToConstant: 40),
            transitionToSettingsButton.widthAnchor.constraint(equalToConstant: 210),
            
            informationLabel.topAnchor.constraint(equalTo: transitionToSettingsButton.bottomAnchor, constant: 5.0),
            informationLabel.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 30.0),
            informationLabel.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -85.0),
            
            findPlaceOrEventButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 25.0),
            findPlaceOrEventButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            findPlaceOrEventButton.heightAnchor.constraint(equalToConstant: 40.0),
            findPlaceOrEventButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            buildingRouteButton.topAnchor.constraint(equalTo: findPlaceOrEventButton.bottomAnchor, constant: 10.0),
            buildingRouteButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            buildingRouteButton.heightAnchor.constraint(equalToConstant: 40.0),
            buildingRouteButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            clearRouteButton.topAnchor.constraint(equalTo: buildingRouteButton.bottomAnchor, constant: 10.0),
            clearRouteButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            clearRouteButton.heightAnchor.constraint(equalToConstant: 40.0),
            clearRouteButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            zoomInMapButton.bottomAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -5.0),
            zoomInMapButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            zoomInMapButton.heightAnchor.constraint(equalToConstant: 40.0),
            zoomInMapButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            zoomOutMapButton.topAnchor.constraint(equalTo: mapView.centerYAnchor, constant: 5.0),
            zoomOutMapButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            zoomOutMapButton.heightAnchor.constraint(equalToConstant: 40.0),
            zoomOutMapButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            showCurrentLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25.0),
            showCurrentLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            showCurrentLocationButton.heightAnchor.constraint(equalToConstant: 40.0),
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            startTrackingLocationButton.bottomAnchor.constraint(equalTo: showCurrentLocationButton.topAnchor, constant: -10.0),
            startTrackingLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -25.0),
            startTrackingLocationButton.heightAnchor.constraint(equalToConstant: 40.0),
            startTrackingLocationButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
