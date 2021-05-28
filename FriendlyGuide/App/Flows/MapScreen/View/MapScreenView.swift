//
//  MapScreenView.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import GoogleMaps

class MapScreenView: UIView {
    private(set) lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.sizeToFit()
        return mapView
    }()

    private(set) lazy var findPlaceOrEventButton = UIButton(title: "",
                                                         image: .none,
                                                         font: .smallButtonFont(),
                                                         cornerRadius: 20.0,
                                                         backgroundColor: .white,
                                                         tintColor: .systemBlue)
    
    private(set) lazy var buildingRouteButton = UIButton(title: "",
                                                         image: .none,
                                                         font: .smallButtonFont(),
                                                         cornerRadius: 20.0,
                                                         backgroundColor: .white,
                                                         tintColor: .systemBlue)
    
    private(set) lazy var clearRouteButton = UIButton(title: "",
                                                             image: .none,
                                                             font: .smallButtonFont(),
                                                             cornerRadius: 20.0,
                                                             backgroundColor: .white,
                                                             tintColor: .systemBlue)
    
    private(set) lazy var zoomInMapButton = UIButton(title: "",
                                                             image: .none,
                                                             font: .smallButtonFont(),
                                                             cornerRadius: 20.0,
                                                             backgroundColor: .white,
                                                             tintColor: .systemBlue)
    
    private(set) lazy var zoomOutMapButton = UIButton(title: "",
                                                         image: .none,
                                                         font: .smallButtonFont(),
                                                         cornerRadius: 20.0,
                                                         backgroundColor: .white,
                                                         tintColor: .systemBlue)
    
    private(set) lazy var showCurrentLocationButton = UIButton(title: "",
                                                             image: .none,
                                                             font: .smallButtonFont(),
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
        findPlaceOrEventButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"),
                                                  for: .normal)
        findPlaceOrEventButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle.fill"),
                                                  for: .highlighted)
        
        buildingRouteButton.setBackgroundImage(UIImage(systemName: "figure.walk.circle"),
                                               for: .normal)
        buildingRouteButton.setBackgroundImage(UIImage(systemName: "figure.walk.circle.fill"),
                                               for: .highlighted)
        
        clearRouteButton.setBackgroundImage(UIImage(systemName: "xmark.circle"),
                                            for: .normal)
        clearRouteButton.setBackgroundImage(UIImage(systemName: "xmark.circle.fill"),
                                            for: .highlighted)
        
        zoomInMapButton.setBackgroundImage(UIImage(systemName: "plus.circle"),
                                           for: .normal)
        zoomInMapButton.setBackgroundImage(UIImage(systemName: "plus.circle.fill"),
                                           for: .highlighted)
        
        zoomOutMapButton.setBackgroundImage(UIImage(systemName: "minus.circle"),
                                            for: .normal)
        zoomOutMapButton.setBackgroundImage(UIImage(systemName: "minus.circle.fill"),
                                            for: .highlighted)
        
        showCurrentLocationButton.setBackgroundImage(UIImage(systemName: "location.circle"),
                                                     for: .normal)
        showCurrentLocationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"),
                                                     for: .highlighted)
        
        self.addSubview(mapView)
        mapView.addSubview(findPlaceOrEventButton)
        mapView.addSubview(buildingRouteButton)
        mapView.addSubview(clearRouteButton)
        mapView.addSubview(zoomInMapButton)
        mapView.addSubview(zoomOutMapButton)
        mapView.addSubview(showCurrentLocationButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            
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
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
