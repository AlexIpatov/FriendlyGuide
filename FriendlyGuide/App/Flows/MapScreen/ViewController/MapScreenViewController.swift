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
    private var initialCoordinate = CLLocationCoordinate2D(latitude: 55.7522, longitude: 37.6156)
    private var currentCoordinate = CLLocationCoordinate2D()
    private var onMapMarker = GMSMarker()
    private var mapScreenCamera = GMSCameraPosition()
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    
    private var selectedOnSliderPlace: Place?
    private var selectedOnSliderEvent: Event?
    private var selectedOnSliderPlaceOrEventImage: UIImage?
    private var selfieImage: UIImage? = UIImage(systemName: "figure.walk")
    private var defaultOnMapMarkerImage = UIImage(systemName: "mappin")
    private var initialSegmentIndex: Int?

    
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
        configureLocationManager()
        configureMapScreenCamera()
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
    
    private func configureLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    func configureMapScreenCamera() {
        mapScreenCamera = GMSCameraPosition.camera(withTarget: initialCoordinate, zoom: 12)
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
        configureShowCurrentLocationButton()
    }
    
    // FindPlaceOrEventButton
    func configureFindPlaceOrEventButton() {
        mapScreenView.findPlaceOrEventButton.addTarget(self, action: #selector(tapFindPlaceOrEventButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapFindPlaceOrEventButton(_ sender: UIButton) {
        let child = OnMapViewController(initialSegmentIndex: initialSegmentIndex ?? 0)
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        child.placeOrEventDelegate = self
        self.present(child, animated: true, completion: nil)
    }
    
    // BuildingRouteButton
    func configureBuildingRouteButton() {
        mapScreenView.buildingRouteButton.addTarget(self, action: #selector(tapBuildingRouteButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapBuildingRouteButton(_ sender: UIButton) {
        print("BuildingRouteButton tapped")
    }
    
    // СlearRouteButton
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapClearRouteButton(_ sender: UIButton) {
        print("ClearRouteButton tapped")
    }
    
    // ZoomInMapButton
    func configureZoomInMapButton() {
        mapScreenView.zoomInMapButton.addTarget(self, action: #selector(tapZoomInMapButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapZoomInMapButton(_ sender: UIButton) {
        let zoomInValue = mapScreenView.mapView.camera.zoom + 1
        mapScreenView.mapView.animate(toZoom: zoomInValue)
    }
    
    // ZoomOutMapButton
    func configureZoomOutMapButton() {
        mapScreenView.zoomOutMapButton.addTarget(self, action: #selector(tapZoomOutMapButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapZoomOutMapButton(_ sender: UIButton) {
        let zoomOutValue = mapScreenView.mapView.camera.zoom - 1
        mapScreenView.mapView.animate(toZoom: zoomOutValue)
    }
    
    // ShowCurrentLocationButton
    func configureShowCurrentLocationButton() {
        mapScreenView.showCurrentLocationButton.addTarget(self, action: #selector(tapShowCurrentLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapShowCurrentLocationButton(_ sender: UIButton) {
        locationManager.stopUpdatingLocation()
        route?.map = nil
        locationManager.requestLocation()
        addOnMapMarker(coordinate: currentCoordinate,
                       markerImage: selfieImage,
                       markerTitle: nil)
        moveMapScreenCameraToPosition(coordinate: currentCoordinate, zoom: 17)
    }
    
    //MARK: - Methods
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
}

//MARK: - Extension with CLLocationManagerDelegate
extension MapScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.first?.coordinate {
            currentCoordinate = coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
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
        let selectedOnSliderPlaceCoordinates = CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude)
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
        let selectedOnSliderEventCoordinates = CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude)
        moveMapScreenCameraToPosition(coordinate: selectedOnSliderEventCoordinates, zoom: 17)
        addOnMapMarker(coordinate: selectedOnSliderEventCoordinates, markerImage: UIImage(systemName: "mappin.and.ellipse"), markerTitle: selectedOnSliderEvent?.title)
        print("selectedOnSliderEvent = \(String(describing: selectedOnSliderEvent))")
    }
    
    func saveSelectedSegmentIndex(index: Int) {
        initialSegmentIndex = index
    }
    
//    func selectPlaceOrEvent<T>(selectedPlaceOrEvent: T) where T : Hashable {
//        if type(of: selectedPlaceOrEvent) == Place.self {
//            guard let selectedPlace: Place = selectedPlaceOrEvent as? Place else {
//                return
//            }
//            selectedOnSliderPlace = selectedPlace
//
//            guard let selectedLatitude = selectedOnSliderPlace?.coords?.lat,
//                  let selectedLongitude = selectedOnSliderPlace?.coords?.lon else {
//                return
//            }
//            let selectedOnSliderPlaceCoordinates = CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude)
//            moveMapScreenCameraToPosition(coordinate: selectedOnSliderPlaceCoordinates, zoom: 17)
//            addOnMapMarker(coordinate: selectedOnSliderPlaceCoordinates, markerImage: UIImage(systemName: "mappin.and.ellipse"), markerTitle: selectedOnSliderPlace?.title)
//        } else if type(of: selectedPlaceOrEvent) == Event.self {
//            guard let selectedEvent: Event = selectedPlaceOrEvent as? Event else { return }
//            selectedOnSliderEvent = selectedEvent
//            // TO DO - Decide with the movement of the camera and show information about the event
//        }
        
//    }
}
