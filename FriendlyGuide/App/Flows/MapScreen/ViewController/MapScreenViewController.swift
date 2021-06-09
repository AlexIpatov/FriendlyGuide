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
    private var backgroundTask: UIBackgroundTaskIdentifier?
    private var locationManager: LocationManager
    private var currentCoordinate = CLLocationCoordinate2D()
    
    private var onMapMarker = GMSMarker()
    private var defaultOnMapMarkerImage = UIImage(systemName: "mappin")

    private var mapScreenCamera = GMSCameraPosition()
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var selectedOnSliderPlace: Place?
    private var selectedOnSliderEvent: Event?
    private var selectedOnSliderPlaceCoordinates = CLLocationCoordinate2D()
    private var selectedOnSliderEventCoordinates = CLLocationCoordinate2D()
    
    private var initialSegmentIndex: Int?
    
    private var selectedOnSliderPlaceOrEventImage: UIImage?
    private var selfieImage: UIImage?
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    //MARK: - Slider properties
    private let transition = SliderTransition()
    
    //MARK: - Init
    init(locationManager: LocationManager,
         selfieImage: UIImage) {
        self.locationManager = locationManager
        self.selfieImage = selfieImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController LifeCycle
    override func loadView() {
        self.view = mapScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureLocationManager()
        configureBackgroundTask()
        configureMapScreenCamera()
        configureMap()
        configureButtons()
    }
    
    //MARK: - Configuration methods
    func configureViewController() {
        self.title = "Карта"
    }
    
    private func configureLocationManager() {
        locationManager.requestLocation()
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let self = self else { return }
                guard let location = location else { return }
                self.currentCoordinate = location.coordinate
                self.routePath?.add(self.currentCoordinate)
                self.route?.path = self.routePath
                let position = GMSCameraPosition.camera(withTarget: self.currentCoordinate, zoom: 17)
                self.addOnMapMarker(coordinate: self.currentCoordinate,
                                    markerImage: self.selfieImage,
                                    markerTitle: nil)
                self.addOnMapRoute(currentCoordinate: self.currentCoordinate)
                self.mapScreenView.mapView.animate(to: position)
            }
    }
    
    func configureBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.backgroundTask!)
            self.backgroundTask = .invalid
        }
    }
    
    func configureMapScreenCamera() {
        mapScreenCamera = GMSCameraPosition.camera(withTarget: currentCoordinate, zoom: 12)
    }
    
    func configureMap() {
        mapScreenView.mapView.delegate = self
        mapScreenView.mapView.camera = mapScreenCamera
    }
    
    //MARK: - Buttons
    func configureButtons() {
        configureFindPlaceOrEventButton()
        configureBuildingRouteButton()
        configureСlearRouteButton()
        configureZoomInMapButton()
        configureZoomOutMapButton()
        configureStartTrackingLocationButton()
        configureShowCurrentLocationButton()
    }
    
    // FindPlaceOrEventButton
    func configureFindPlaceOrEventButton() {
        mapScreenView.findPlaceOrEventButton.addTarget(self, action: #selector(tapFindPlaceOrEventButton(_:)), for: .touchUpInside)
    }
    @objc func tapFindPlaceOrEventButton(_ sender: UIButton) {
        showOnMapSliderViewController()
    }
    
    // BuildingRouteButton
    func configureBuildingRouteButton() {
        mapScreenView.buildingRouteButton.addTarget(self, action: #selector(tapBuildingRouteButton(_:)), for: .touchUpInside)
    }
    @objc func tapBuildingRouteButton(_ sender: UIButton) {
        print("BuildingRouteButton tapped")
        showRouteToPlaceOrEvent()
        //            route?.map = nil
        //            route = GMSPolyline()
        //            routePath = GMSMutablePath()
        //            route?.map = mapScreenView.mapView
    }
    
    // СlearRouteButton
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    @objc func tapClearRouteButton(_ sender: UIButton) {
        print("ClearRouteButton tapped")
        route?.map = nil
    }
    
    // ZoomInMapButton
    func configureZoomInMapButton() {
        mapScreenView.zoomInMapButton.addTarget(self, action: #selector(tapZoomInMapButton(_:)), for: .touchUpInside)
    }
    @objc func tapZoomInMapButton(_ sender: UIButton) {
        zoomInMap()
    }
    
    // ZoomOutMapButton
    func configureZoomOutMapButton() {
        mapScreenView.zoomOutMapButton.addTarget(self, action: #selector(tapZoomOutMapButton(_:)), for: .touchUpInside)
    }
    @objc func tapZoomOutMapButton(_ sender: UIButton) {
        zoomOutMap()
    }
    
    // StartTrackingLocationButton
    func configureStartTrackingLocationButton() {
        mapScreenView.startTrackingLocationButton.addTarget(self, action: #selector(tapStartTrackingLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapStartTrackingLocationButton(_ sender: UIButton) {
        startTrackingLocation()
    }
    
    // ShowCurrentLocationButton
    func configureShowCurrentLocationButton() {
        mapScreenView.showCurrentLocationButton.addTarget(self, action: #selector(tapShowCurrentLocationButton(_:)), for: .touchUpInside)
    }
    @objc func tapShowCurrentLocationButton(_ sender: UIButton) {
        showCurrentLocation()
    }
    
    //MARK: - Methods
    func showOnMapSliderViewController() {
        let child = OnMapSliderViewController(initialSegmentIndex: initialSegmentIndex ?? 0)
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        child.placeOrEventDelegate = self
        self.present(child, animated: true, completion: nil)
    }
    
    func startTrackingLocation() {
        if mapScreenView.startTrackingLocationButton.tag == 0 {
            // Run tracking
            setStartTrackingLocationButtonToStatusTapped()
            mapScreenView.mapView.animate(toZoom: 17)
            locationManager.startUpdatingLocation()
        } else if mapScreenView.startTrackingLocationButton.tag == 1 {
            // Stop tracking
            locationManager.stopUpdatingLocation()
            setStartTrackingLocationButtonToStatusUntapped()
        }
    }
    
    func setStartTrackingLocationButtonToStatusTapped() {
        mapScreenView.startTrackingLocationButton.tag = 1
        mapScreenView.startTrackingLocationButton.setBackgroundImage(UIImage(systemName: "figure.walk.circle.fill"), for: .normal)
        mapScreenView.startTrackingLocationButton.tintColor = .systemGreen
    }
    
    func setStartTrackingLocationButtonToStatusUntapped() {
        mapScreenView.startTrackingLocationButton.tag = 0
        mapScreenView.startTrackingLocationButton.setBackgroundImage(UIImage(systemName: "figure.walk.circle"), for: .normal)
        mapScreenView.startTrackingLocationButton.tintColor = .systemBlue
    }
    
    func showRouteToPlaceOrEvent() {
//        route?.map = nil
//        route = GMSPolyline()
//        let path = GMSPath(fromEncodedPath: <#T##String#>)
//        routePath = GMSMutablePath(path: <#T##GMSPath#>)
    }
    
    func showCurrentLocation() {
        locationManager.stopUpdatingLocation()
        if mapScreenView.startTrackingLocationButton.tag == 1 {
            setStartTrackingLocationButtonToStatusUntapped()
        }
        addOnMapMarker(coordinate: currentCoordinate,
                       markerImage: selfieImage,
                       markerTitle: nil)
        moveMapScreenCameraToPosition(coordinate: currentCoordinate, zoom: 17)
    }
    
    func addOnMapMarker(coordinate: CLLocationCoordinate2D,
                        markerImage: UIImage?,
                        markerTitle: String?) {
        let frame = CGRect(x: 0, y: 0, width: 30.0, height: 30.0)
        let onMapMarkerImageView = UIImageView(frame: frame)
        onMapMarkerImageView.tintColor = .systemRed
        if let image = markerImage {
            onMapMarkerImageView.image = image
            onMapMarkerImageView.layer.cornerRadius = onMapMarkerImageView.bounds.width / 2
            onMapMarkerImageView.clipsToBounds = true
        } else {
            onMapMarkerImageView.image = defaultOnMapMarkerImage
        }
        
        onMapMarker.iconView = onMapMarkerImageView
        if let title = markerTitle {
            onMapMarker.title = title
        }
        
        onMapMarker.position = coordinate
        onMapMarker.map = mapScreenView.mapView
    }
    
    func deleteOnMapMarker() {
        onMapMarker.map = nil
        onMapMarker = GMSMarker()
    }
    
    func addOnMapRoute(currentCoordinate: CLLocationCoordinate2D) {
        routePath?.add(currentCoordinate)
        route?.strokeColor = .systemGreen
        route?.path = routePath
    }
    
    func moveMapScreenCameraToPosition(coordinate: CLLocationCoordinate2D,
                                       zoom: Float) {
        mapScreenCamera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoom)
        mapScreenView.mapView.camera = mapScreenCamera
        mapScreenView.mapView.animate(to: mapScreenView.mapView.camera)
    }
    
    func zoomInMap() {
        let zoomInValue = mapScreenView.mapView.camera.zoom + 1
        mapScreenView.mapView.animate(toZoom: zoomInValue)
    }
    
    func zoomOutMap() {
        let zoomOutValue = mapScreenView.mapView.camera.zoom - 1
        mapScreenView.mapView.animate(toZoom: zoomOutValue)
    }
}

//MARK: - Extension with GMSMapViewDelegate
extension MapScreenViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }
}

//MARK: - Extension with OnMapViewControllerDelegate
extension MapScreenViewController: OnMapViewControllerDelegate {
    func selectPlace(selectedPlace: Place) {
        selectedOnSliderPlace = selectedPlace
        guard let selectedLatitude = selectedOnSliderPlace?.coords?.lat,
              let selectedLongitude = selectedOnSliderPlace?.coords?.lon else {
            return
        }
        selectedOnSliderPlaceCoordinates = CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude)
        moveMapScreenCameraToPosition(coordinate: selectedOnSliderPlaceCoordinates, zoom: 17)
        addOnMapMarker(coordinate: selectedOnSliderPlaceCoordinates, markerImage: UIImage(systemName: "mappin.and.ellipse"), markerTitle: selectedOnSliderPlace?.title)
        print("selectedOnSliderPlace = \(String(describing: selectedOnSliderPlace))")
    }
    
    func selectEvent(selectedEvent: Event) {
        selectedOnSliderEvent = selectedEvent
        guard let selectedLatitude = selectedOnSliderEvent?.place?.coords?.lat,
              let selectedLongitude = selectedOnSliderEvent?.place?.coords?.lon else {
            return
        }
        selectedOnSliderEventCoordinates = CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude)
        moveMapScreenCameraToPosition(coordinate: selectedOnSliderEventCoordinates, zoom: 17)
        addOnMapMarker(coordinate: selectedOnSliderEventCoordinates, markerImage: UIImage(systemName: "mappin.and.ellipse"), markerTitle: selectedOnSliderEvent?.title)
        print("selectedOnSliderEvent = \(String(describing: selectedOnSliderEvent))")
    }
    
    func saveSelectedSegmentIndex(index: Int) {
        initialSegmentIndex = index
    }
}
