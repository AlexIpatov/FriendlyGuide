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
        UIComponentsFactory.makeMapView()
    }()
    
    private(set) lazy var showCurrentLocationButton: UIButton = {
        UIComponentsFactory.makeButton(title: "",
                   font: .systemFont(ofSize: 17),
                   backgroundColor: .white,
                   cornerRadius: 20.0)
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        showCurrentLocationButton.setBackgroundImage(UIImage(systemName: "location.circle"), for: .normal)
        showCurrentLocationButton.setBackgroundImage(UIImage(systemName: "location.circle.fill"), for: .highlighted)
        
        self.addSubview(mapView)
        mapView.addSubview(showCurrentLocationButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            
            showCurrentLocationButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 30.0),
            showCurrentLocationButton.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -30.0),
            showCurrentLocationButton.heightAnchor.constraint(equalToConstant: 40.0),
            showCurrentLocationButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
