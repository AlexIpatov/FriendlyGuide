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
    
    private var initialRegion = MKCoordinateRegion()
    private let initialLatitudinalMetersForPresenting: CLLocationDegrees = 5000
    private let initialLongitudinalMetersForPresenting: CLLocationDegrees = 5000
    private let latitudinalMetersForPresenting: CLLocationDegrees = 300
    private let longitudinalMetersForPresenting: CLLocationDegrees = 300
    
    private let minSpanLatitudeDelta: CLLocationDegrees = 0.002
    private let maxSpanLatitudeDelta: CLLocationDegrees = 90.0
    private var isZoomOut: Bool = false
    
    private var currentRegion = MKCoordinateRegion()
    private var currentSpan = MKCoordinateSpan()
    private var currentCoordinate = CLLocationCoordinate2D()
    
    private var initialSegmentIndex: Int?
    
    private var selectedOnSliderPlace: Place?
    private var selectedOnSliderEvent: Event?
    
    private var entitiesForAnnotationArray: [EntityForAnnotation] = []
    private var placeForAnnotation: EntityForAnnotation?
    private var eventForAnnotation: EntityForAnnotation?
    
    private var selectedOnSliderPlaceCoordinates = CLLocationCoordinate2D()
    private var selectedOnSliderEventCoordinates = CLLocationCoordinate2D()
    
    private var selectedOnSliderPlaceOrEventImage: UIImage?
    
    private var selfieImage: UIImage?
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private var allPlaces = [
        Place(id: 123, title: "Государственный музей А.С.Пушкина", address: "Хрущёвский пер., 2/12", coords: Coordinates(lat: 55.743548, lon: 37.597612), subway: "Кропоткинская", images: []),
        Place(id: 234, title: "Государственный академический Большой театр России", address: "Театральная площадь, 1", coords: Coordinates(lat: 55.760221, lon: 37.618561), subway: "Театральная", images: []),
        Place(id: 345, title: "Радуга Кино", address: "просп. Андропова, 8", coords: Coordinates(lat: 55.695720, lon: 37.665070), subway: "Технопарк", images: []),
        Place(id: 111, title: "Если одинаковое поле без координат", address: "", coords: nil, subway: "", images: [])
    ]
    
    private var allEvents = [
        Event(id: 456, title: "Выступление клоунов", dates: [], images: [], place: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 55.719438, lon: 37.627026))),
        Event(id: 567, title: "Чемпионат мира по боксу", dates: [], images: [], place: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 55.714312, lon: 37.567163))),
        Event(id: 678, title: "Выставка кошек", dates: [], images: [], place: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 55.798555, lon: 37.670538))),
        Event(id: 222, title: "Если одинаковое поле без координат", dates: [], images: [], place: nil)
    ]
    
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
        configureLocationManager()
        configureMap()
        configureButtons()
        loadDataFromNetwork()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled() {
            if mapScreenView.startTrackingLocationButton.tag == 1 {
                locationManager.startUpdatingLocationInLocationManager()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocationInLocationManager()
        }
    }
    
    func configureViewController() {
        self.title = "Карта"
    }
    
    //MARK: - Background Task
    func configureBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self,
                  let backgroundTask = self.backgroundTask else { return }
            UIApplication.shared.endBackgroundTask(backgroundTask)
            self.backgroundTask = .invalid
        }
    }
    
    //MARK: - Location Manager
    func configureLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            _ = locationManager
                .currentLocation
                .asObservable()
                .bind { [weak self] location in
                    guard let self = self else { return }
                    guard let location = location else { return }
                    self.currentCoordinate = location.coordinate
                    self.currentRegion = self.makeRegionForDisplay(center: self.currentCoordinate)
                    self.showRegion(region: self.currentRegion)
                    self.configureCurrentCoordinateLatLonLabels()
                }
        }
    }
    
    //MARK: - Load Data From Network
    func loadDataFromNetwork() {
        //TO DO - need to implement
        
        showAllAnnotations(placesArray: allPlaces, eventsArray: allEvents)
        
    }
    
    //MARK: - Region
    func makeRegionForDisplay(center: CLLocationCoordinate2D) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: center,
                                  latitudinalMeters: self.latitudinalMetersForPresenting,
                                  longitudinalMeters: self.longitudinalMetersForPresenting)
    }
    
    func showRegion(region: MKCoordinateRegion) {
        self.mapScreenView.mapView.setRegion(region, animated: true)
    }
    
    func showCurrentRegionWithZoom(zoom: Double) {
        currentRegion = self.mapScreenView.mapView.region
        currentSpan = currentRegion.span
        if isZoomOut {
            if currentSpan.latitudeDelta < maxSpanLatitudeDelta {
                currentSpan.latitudeDelta = currentSpan.latitudeDelta * zoom
                currentSpan.longitudeDelta = currentSpan.longitudeDelta * zoom
                currentRegion.span = currentSpan
            }
        } else {
            if currentSpan.latitudeDelta > minSpanLatitudeDelta {
                currentSpan.latitudeDelta = currentSpan.latitudeDelta * zoom
                currentSpan.longitudeDelta = currentSpan.longitudeDelta * zoom
                currentRegion.span = currentSpan
            }
        }
        showRegion(region: currentRegion)
    }
    
    func configureCurrentCoordinateLatLonLabels() {
        let currentCoordinate = currentCoordinate
        mapScreenView.latitudeValueLabel.text = String(format: "%g\u{00B0}",
                                                       currentCoordinate.latitude)
        mapScreenView.longitudeValueLabel.text = String(format: "%g\u{00B0}",
                                                        currentCoordinate.longitude)
    }
    
    //MARK: - Map
    func configureMap() {
        mapScreenView.mapView.delegate = self
        mapScreenView.mapView.showsCompass = false
        if CLLocationManager.locationServicesEnabled() {
            configureMapWhenLocationServicesEnabled()
        } else {
            configureMapWhenLocationServicesDisabled()
        }
    }
    
    func configureMapWhenLocationServicesEnabled() {
        mapScreenView.mapView.showsUserLocation = true
        initialRegion = MKCoordinateRegion(center: currentCoordinate,
                                           latitudinalMeters: initialLatitudinalMetersForPresenting,
                                           longitudinalMeters: initialLongitudinalMetersForPresenting)
        self.showRegion(region: initialRegion)
        configureCurrentCoordinateLatLonLabels()
    }
    
    func configureMapWhenLocationServicesDisabled() {
        mapScreenView.mapView.showsUserLocation = false
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
        configureButtonsAndLabelsVisibility()
    }
    
    //MARK: - TransitionToSettingsButton
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
    //MARK: - Alerts
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
    
    //MARK: - FindPlaceOrEventButton
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
    
    //MARK: - BuildingRouteButton
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
    
    //MARK: - СlearRouteButton
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    @objc func tapClearRouteButton(_ sender: UIButton) {
        //TO DO - need to implement
        
    }
    
    //MARK: - ZoomInMapButton
    func configureZoomInMapButton() {
        mapScreenView.zoomInMapButton.addTarget(self, action: #selector(tapZoomInMapButton(_:)), for: .touchUpInside)
    }
    @objc func tapZoomInMapButton(_ sender: UIButton) {
        zoomInMap()
    }
    
    func zoomInMap() {
        isZoomOut = false
        showCurrentRegionWithZoom(zoom: 0.5)
    }
    
    //MARK: - ZoomOutMapButton
    func configureZoomOutMapButton() {
        mapScreenView.zoomOutMapButton.addTarget(self, action: #selector(tapZoomOutMapButton(_:)), for: .touchUpInside)
    }
    @objc func tapZoomOutMapButton(_ sender: UIButton) {
        zoomOutMap()
    }
    
    func zoomOutMap() {
        isZoomOut = true
        showCurrentRegionWithZoom(zoom: 2.0)
    }
    
    //MARK: - StartTrackingLocationButton
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
        } else if mapScreenView.startTrackingLocationButton.tag == 1 {
            // Stop tracking
            setStartTrackingLocationButtonToStatusUntapped()
            locationManager.stopUpdatingLocationInLocationManager()
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
    
    //MARK: - ShowCurrentLocationButton
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
        locationManager.requestLocationInLocationManager()
        configureCurrentCoordinateLatLonLabels()
    }
    
    //MARK: - Buttons And Labels Visibility
    func configureButtonsAndLabelsVisibility() {
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
}

//MARK: - Extension with MKMapViewDelegate
extension MapScreenViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EntityForAnnotation else { return nil }
        var viewMarker: MKMarkerAnnotationView
        let idView = "marker"
        if let view = mapScreenView.mapView.dequeueReusableAnnotationView(withIdentifier: idView) as? MKMarkerAnnotationView {
            view.annotation = annotation
            viewMarker = view
        } else {
            viewMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: idView)
            viewMarker.canShowCallout = true
            viewMarker.calloutOffset = CGPoint(x: 0, y: 5)
            let buttonForAnnotation: UIButton = {
                let button = UIButton(type: .detailDisclosure)
                button.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.circle"), for: .normal)
                button.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.circle.fill"), for: .highlighted)
                return button
            }()
            viewMarker.rightCalloutAccessoryView = buttonForAnnotation
        }
        viewMarker.markerTintColor = annotation.color
        return viewMarker
    }
}

//MARK: - Extension with OnMapViewControllerDelegate
extension MapScreenViewController: OnMapViewControllerDelegate {
    func selectPlace(selectedPlace: Place) {
        selectedOnSliderPlace = selectedPlace
        guard let selectedPlaceCoordinatesLat = selectedOnSliderPlace?.coords?.lat,
              let selectedPlaceCoordinatesLon = selectedOnSliderPlace?.coords?.lon,
              let selectedPlaceTitle = selectedOnSliderPlace?.title else {
            return
        }
        let selectedPlaceCoordinates = CLLocationCoordinate2D(latitude: selectedPlaceCoordinatesLat,
                                                              longitude: selectedPlaceCoordinatesLon)
        let selectedPlaceAddress = selectedOnSliderPlace?.address
        
        showAnnotation(coordinate: selectedPlaceCoordinates,
                       title: selectedPlaceTitle,
                       subtitle: selectedPlaceAddress ?? "",
                       color: .systemGreen)
    }
    
    func selectEvent(selectedEvent: Event) {
        selectedOnSliderEvent = selectedEvent
        guard let selectedEventCoordinatesLat = selectedOnSliderEvent?.place?.coords?.lat,
              let selectedEventCoordinatesLon = selectedOnSliderEvent?.place?.coords?.lon,
              let selectedEventTitle = selectedOnSliderEvent?.title else {
            return
        }
        let selectedEventCoordinates = CLLocationCoordinate2D(latitude: selectedEventCoordinatesLat,
                                                              longitude: selectedEventCoordinatesLon)
        let selectedEventAddress = selectedOnSliderEvent?.place?.address
        
        showAnnotation(coordinate: selectedEventCoordinates,
                       title: selectedEventTitle,
                       subtitle: selectedEventAddress ?? "",
                       color: .systemOrange)
    }
    
    func showAnnotation(coordinate: CLLocationCoordinate2D,
                        title: String,
                        subtitle: String,
                        color: UIColor) {
        let entityForAnnotation = EntityForAnnotation(coordinate: coordinate,
                                                      title: title,
                                                      subtitle: subtitle,
                                                      color: color)
        currentRegion = makeRegionForDisplay(center: coordinate)
        mapScreenView.mapView.addAnnotation(entityForAnnotation)
        showRegion(region: currentRegion)
    }
    
    func showAllAnnotations(placesArray: [Place], eventsArray: [Event]) {
        entitiesForAnnotationArray = []
        
        for place in placesArray {
            if let placeCoordinatesLat = place.coords?.lat,
               let placeCoordinatesLon = place.coords?.lon {
                let placeCoordinate = CLLocationCoordinate2D(latitude: placeCoordinatesLat,
                                                              longitude: placeCoordinatesLon)
                let entityForAnnotationFromPlace = EntityForAnnotation(coordinate: placeCoordinate,
                                                                       title: place.title,
                                                                       subtitle: place.address,
                                                                       color: .systemGreen)
                entitiesForAnnotationArray.append(entityForAnnotationFromPlace)
            }
        }
        
        for event in eventsArray {
            if let eventCoordinatesLat = event.place?.coords?.lat,
               let eventCoordinatesLon = event.place?.coords?.lon {
                let eventCoordinate = CLLocationCoordinate2D(latitude: eventCoordinatesLat,
                                                              longitude: eventCoordinatesLon)
                let entityForAnnotationFromEvent = EntityForAnnotation(coordinate: eventCoordinate,
                                                                       title: event.title,
                                                                       subtitle: event.place?.address,
                                                                       color: .systemOrange)
                entitiesForAnnotationArray.append(entityForAnnotationFromEvent)
                
            }
            mapScreenView.mapView.addAnnotations(entitiesForAnnotationArray)
        }
    }
    
    func saveSelectedSegmentIndex(index: Int) {
        initialSegmentIndex = index
    }
}
