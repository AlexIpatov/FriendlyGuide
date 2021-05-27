//
//  MapScreenViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapScreenViewController: UIViewController {
    // MARK: - UI components
    private lazy var mapScreenView: MapScreenView = {
        return MapScreenView()
    }()
    
    //MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentCoordinate = CLLocationCoordinate2D()
    private var onMapMarker = GMSMarker()
    private var camera = GMSCameraPosition()
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    //MARK: - Slider properties
    private let transition = SliderTransition()
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureMap()
        configureButtons()
    }
    
    override func loadView() {
        self.view = mapScreenView
    }
    
    //MARK: - Configuration methods
    func configureViewController() {
        self.title = "Карта"
    }
    
    func configureMap() {
        mapScreenView.mapView.delegate = self
    }
    
    //MARK: - Buttons
    func configureButtons() {
        configureFindPlaceOrEventButton()
        configureBuildingRouteButton()
        configureСlearRouteButton()
        configureZoomInMapButton()
        configureZoomOutMapButton()
        configureShowCurrentLocationButton()
    }
    
    func configureFindPlaceOrEventButton() {
        mapScreenView.findPlaceOrEventButton.addTarget(self, action: #selector(tapFindPlaceOrEventButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapFindPlaceOrEventButton(_ sender: UIButton) {
        let child = OnMapViewController()
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        self.present(child, animated: true, completion: nil)
    }
    
    func configureBuildingRouteButton() {
        mapScreenView.buildingRouteButton.addTarget(self, action: #selector(tapBuildingRouteButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapBuildingRouteButton(_ sender: UIButton) {
        print("BuildingRouteButton tapped")
    }
    
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapClearRouteButton(_ sender: UIButton) {
        print("ClearRouteButton tapped")
    }
    
    func configureZoomInMapButton() {
        mapScreenView.zoomInMapButton.addTarget(self, action: #selector(tapZoomInMapButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapZoomInMapButton(_ sender: UIButton) {
        print("ZoomInMapButton tapped")
    }
    
    func configureZoomOutMapButton() {
        mapScreenView.zoomOutMapButton.addTarget(self, action: #selector(tapZoomOutMapButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapZoomOutMapButton(_ sender: UIButton) {
        print("ZoomOutMapButton tapped")
    }
    
    func configureShowCurrentLocationButton() {
        mapScreenView.showCurrentLocationButton.addTarget(self, action: #selector(tapShowCurrentLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapShowCurrentLocationButton(_ sender: UIButton) {
        print("ShowCurrentLocationButton tapped")
    }
}

extension MapScreenViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}
