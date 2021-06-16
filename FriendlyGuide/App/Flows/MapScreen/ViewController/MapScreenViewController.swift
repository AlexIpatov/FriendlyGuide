//
//  MapScreenViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import MapKit
import CoreLocation

class MapScreenViewController: UIViewController {
    // MARK: - UI components
    private lazy var mapScreenView: MapScreenView = {
        return MapScreenView()
    }()
    
    //MARK: - Properties
    private var backgroundTask: UIBackgroundTaskIdentifier?
    private var locationManager: LocationManager
    
    private var onMapMarker = MKMarkerAnnotationView()
    private var defaultOnMapMarkerImage = UIImage(systemName: "mappin")

    private var mapScreenCamera = MKMapCamera()
    
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
        configureBackgroundTask()
        configureMapDependingOnLocationServicesStatus()
        configureButtons()
        configureButtonsAndLabelsVisibilityDependingOnLocationServicesStatus()
    }
    
    //MARK: - Configuration methods
    func configureViewController() {
        self.title = "Карта"
    }
    
    func configureBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self,
                  let backgroundTask = self.backgroundTask else { return }
            UIApplication.shared.endBackgroundTask(backgroundTask)
            self.backgroundTask = .invalid
        }
    }
    
    func configureMapDependingOnLocationServicesStatus() {
        if CLLocationManager.locationServicesEnabled() {
            configureLocationManager()
            configureMapScreenCamera()
            configureMap()
        }
    }
    
    private func configureLocationManager() {       
        //TO DO - need to implement

    }
    
    func configureMapScreenCamera() {
        mapScreenCamera.centerCoordinate = locationManager.getCurrentCoordinateInLocationManager()
        mapScreenCamera.centerCoordinateDistance = 1000
    }
    
    func configureMap() {
        mapScreenView.mapView.delegate = self
        mapScreenView.mapView.camera = mapScreenCamera
        mapScreenView.mapView.showsUserLocation = true
        configureCurrentCoordinateLatLonLabels()
    }
    
    func configureCurrentCoordinateLatLonLabels() {
        let currentCoordinate = locationManager.getCurrentCoordinateInLocationManager()
        mapScreenView.latitudeValueLabel.text = String(format: "%g\u{00B0}",
                                                       currentCoordinate.latitude)
        mapScreenView.longitudeValueLabel.text = String(format: "%g\u{00B0}",
                                                        currentCoordinate.longitude)
    }
    
    //MARK: - Buttons
    func configureButtons() {
        configureTransitionToSettingsButton()
        configureFindPlaceOrEventButton()
        configureBuildingRouteButton()
        configureСlearRouteButton()
        configureZoomInMapButton()
        configureZoomOutMapButton()
        configureStartTrackingLocationButton()
        configureShowCurrentLocationButton()
    }
    
    // TransitionToSettingsButton
    func configureTransitionToSettingsButton() {
        mapScreenView.transitionToSettingsButton.addTarget(self, action: #selector(tapTransitionToSettingsButton(_:)), for: .touchUpInside)
    }
    @objc func tapTransitionToSettingsButton(_ sender: UIButton) {
        checkLocationServicesStatus()
    }
    
    func checkLocationServicesStatus() {
        if CLLocationManager.locationServicesEnabled() {
            showInformationAlert()
        } else {
            showTransitionAlert()
        }
    }
    
    func showInformationAlert() {
        let informationAlert = UIAlertController(
            title: "Службы геолокации включены.\nПерезапустите приложение",
            message: nil,
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                         handler: nil)
        informationAlert.addAction(okAction)
        self.present(informationAlert, animated: true, completion: nil)
    }
    
    func showTransitionAlert() {
        let transitionAlert = UIAlertController(
            title: "Вы хотите перейти в настройки и включить службы геолокации?",
            message: nil,
            preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Настройки",
                                           style: .default) { (alert) in
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION_SERVICES") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена",
                                         style: .cancel,
                                         handler: nil)
        transitionAlert.addAction(settingsAction)
        transitionAlert.addAction(cancelAction)
        self.present(transitionAlert, animated: true, completion: nil)
    }
    
    // FindPlaceOrEventButton
    func configureFindPlaceOrEventButton() {
        mapScreenView.findPlaceOrEventButton.addTarget(self, action: #selector(tapFindPlaceOrEventButton(_:)), for: .touchUpInside)
    }
    @objc func tapFindPlaceOrEventButton(_ sender: UIButton) {
        showOnMapSliderViewController()
    }
    
    func showOnMapSliderViewController() {
        let child = OnMapSliderViewController(initialSegmentIndex: initialSegmentIndex ?? 0)
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
        showRouteToPlaceOrEvent()
    }
    
    func showRouteToPlaceOrEvent() {
        //TO DO - need to implement
    }
    
    // СlearRouteButton
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    @objc func tapClearRouteButton(_ sender: UIButton) {
        //TO DO - need to implement

    }
    
    // ZoomInMapButton
    func configureZoomInMapButton() {
        mapScreenView.zoomInMapButton.addTarget(self, action: #selector(tapZoomInMapButton(_:)), for: .touchUpInside)
    }
    @objc func tapZoomInMapButton(_ sender: UIButton) {
        zoomInMap()
    }
    
    func zoomInMap() {
        //TO DO - need to implement

    }
    
    // ZoomOutMapButton
    func configureZoomOutMapButton() {
        mapScreenView.zoomOutMapButton.addTarget(self, action: #selector(tapZoomOutMapButton(_:)), for: .touchUpInside)
    }
    @objc func tapZoomOutMapButton(_ sender: UIButton) {
        zoomOutMap()
    }
    
    func zoomOutMap() {
        //TO DO - need to implement

    }
    
    // StartTrackingLocationButton
    func configureStartTrackingLocationButton() {
        mapScreenView.startTrackingLocationButton.addTarget(self, action: #selector(tapStartTrackingLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapStartTrackingLocationButton(_ sender: UIButton) {
        startTrackingLocation()
    }
    
    func startTrackingLocation() {
        if mapScreenView.startTrackingLocationButton.tag == 0 {
            // Run tracking
            setStartTrackingLocationButtonToStatusTapped()
            locationManager.startUpdatingLocationInLocationManager()
            //TO DO - need to implement

        } else if mapScreenView.startTrackingLocationButton.tag == 1 {
            // Stop tracking
            locationManager.stopUpdatingLocationInLocationManager()
            setStartTrackingLocationButtonToStatusUntapped()
            //TO DO - need to implement

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
    
    // ShowCurrentLocationButton
    func configureShowCurrentLocationButton() {
        mapScreenView.showCurrentLocationButton.addTarget(self, action: #selector(tapShowCurrentLocationButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapShowCurrentLocationButton(_ sender: UIButton) {
        showCurrentLocation()
    }
    
    func showCurrentLocation() {
        locationManager.stopUpdatingLocationInLocationManager()
        if mapScreenView.startTrackingLocationButton.tag == 1 {
            setStartTrackingLocationButtonToStatusUntapped()
        }
        //TO DO - need to implement

    }
    
    func configureButtonsAndLabelsVisibilityDependingOnLocationServicesStatus() {
        if CLLocationManager.locationServicesEnabled() {
            mapScreenView.transitionToSettingsButton.isHidden = true
            mapScreenView.informationLabel.isHidden = true
            
            mapScreenView.latitudeLabel.isHidden = false
            mapScreenView.longitudeLabel.isHidden = false
            mapScreenView.latitudeValueLabel.isHidden = false
            mapScreenView.longitudeValueLabel.isHidden = false
            mapScreenView.startTrackingLocationButton.isHidden = false
            mapScreenView.showCurrentLocationButton.isHidden = false
        } else {
            mapScreenView.transitionToSettingsButton.isHidden = false
            mapScreenView.informationLabel.isHidden = false
            
            mapScreenView.latitudeLabel.isHidden = true
            mapScreenView.longitudeLabel.isHidden = true
            mapScreenView.latitudeValueLabel.isHidden = true
            mapScreenView.longitudeValueLabel.isHidden = true
            mapScreenView.startTrackingLocationButton.isHidden = true
            mapScreenView.showCurrentLocationButton.isHidden = true
        }
    }
    
    //MARK: - Methods
    func addOnMapMarker(coordinate: CLLocationCoordinate2D,
                        markerImage: UIImage?,
                        markerTitle: String?) {

    }

    func deleteOnMapMarker() {
        //TO DO - need to implement

    }

    func addOnMapRoute(currentCoordinate: CLLocationCoordinate2D) {
        //TO DO - need to implement

    }
    
    func moveCameraToPosition(location: CLLocation?,
                              altitude: CLLocationDistance) {
        //TO DO - need to implement

    }
}

//MARK: - Extension with MKMapViewDelegate
extension MapScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(userLocation)
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
        //TO DO - need to implement

        print("selectedOnSliderPlace = \(String(describing: selectedOnSliderPlace))")
    }
    
    func selectEvent(selectedEvent: Event) {
        selectedOnSliderEvent = selectedEvent
        guard let selectedLatitude = selectedOnSliderEvent?.place?.coords?.lat,
              let selectedLongitude = selectedOnSliderEvent?.place?.coords?.lon else {
            return
        }
        selectedOnSliderEventCoordinates = CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude)
        //TO DO - need to implement

        print("selectedOnSliderEvent = \(String(describing: selectedOnSliderEvent))")
    }
    
    func saveSelectedSegmentIndex(index: Int) {
        initialSegmentIndex = index
    }
}
