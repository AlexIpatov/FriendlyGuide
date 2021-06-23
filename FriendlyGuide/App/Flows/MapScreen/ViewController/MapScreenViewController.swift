//
//  MapScreenViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import MapKit
import CoreLocation

enum RouteBuildingError: Error {
        case routeBuildingError(Error)
}

class MapScreenViewController: UIViewController {
    // MARK: - UI components
    private lazy var mapScreenView: MapScreenView = {
        return MapScreenView()
    }()
    
    //MARK: - Properties
    private var backgroundTask: UIBackgroundTaskIdentifier?
    private var locationManager = LocationManager.instance
    private var dataProvider: DataProvider
    
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
    private var selectedEntityCoordinates = CLLocationCoordinate2D()
    
    private var entitiesForAnnotationArray: [EntityForAnnotation] = []
    
    private var selectedOnSliderPlaceOrEventImage: UIImage?
    
    private var selfieImage: UIImage?
    
    private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private var allPlaces: [Place] = []
    private var allEvents: [Event] = []
    
    //MARK: - Slider properties
    private let transition = SliderTransition()
    
    //MARK: - Init
    init(
         dataProvider: DataProvider,
         selfieImage: UIImage) {
        self.dataProvider = dataProvider
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
        configureNavigationBar()
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
    
    //MARK: - Configure ViewController
    func configureViewController() {
        self.title = "Карта"
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: mapScreenView.reloadDataButton)
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
    private func loadDataFromNetwork() {
        let currentDate = String(Date().timeIntervalSince1970)
        self.dataProvider.getData(cityTag: "",
                                  actualSince: currentDate,
                                  showingSince: currentDate) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch response {
                case .success((let events, _, let places)):
                    self.allPlaces = places
                    self.allEvents = events
                    self.showAllAnnotations(placesArray: places, eventsArray: events)
                case .failure(let error):
                    self.showAlert(with: "Ошибка загрузки данных о местах и событиях",
                                   and: error.localizedDescription)
                }
            }
        }
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
        configureReloadDataButton()
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
            showIfLocationServicesEnabledAlert()
        } else {
            showIfLocationServicesDisabledAlert()
        }
    }
    
    //MARK: - ReloadDataButton

    func configureReloadDataButton() {
        mapScreenView.reloadDataButton.addTarget(self, action: #selector(tapReloadDataButton(_:)), for: .touchUpInside)
    }
    @objc func tapReloadDataButton(_ sender: UIButton) {
        print("ReloadDataButton tapped")
        loadDataFromNetwork()
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
        showRouteToPlaceOrEvent()
    }
    
    func showRouteToPlaceOrEvent() {
        if CLLocationManager.locationServicesEnabled() {
            let startRoutePoint = MKPlacemark(coordinate: currentCoordinate)
            let endRoutePoint = MKPlacemark(coordinate: selectedEntityCoordinates)
            buildRoute(startRoutePoint: startRoutePoint,
                       endRoutePoint: endRoutePoint,
                       transportType: .walking)
        } else {
            showIfLocationServicesDisabledAlert()
        }
    }
    
    func buildRoute(startRoutePoint: MKPlacemark,
                    endRoutePoint: MKPlacemark,
                    transportType: MKDirectionsTransportType) {
        mapScreenView.mapView.removeOverlays(mapScreenView.mapView.overlays)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startRoutePoint)
        request.destination = MKMapItem(placemark: endRoutePoint)
        request.transportType = transportType
        
        let direction = MKDirections(request: request)
        direction.calculate { (response, error) in
            guard let response = response else {
                self.showIfCanNotBuildRoute()
                return
            }
            for route in response.routes {
                self.mapScreenView.mapView.addOverlay(route.polyline)
            }
        }
    }
    
    //MARK: - СlearRouteButton
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    @objc func tapClearRouteButton(_ sender: UIButton) {
        mapScreenView.mapView.removeOverlays(mapScreenView.mapView.overlays)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if CLLocationManager.locationServicesEnabled() {
            let destinationEntity = view.annotation as! EntityForAnnotation
            let startRoutePoint = MKPlacemark(coordinate: currentCoordinate)
            let endRoutePoint = MKPlacemark(coordinate: destinationEntity.coordinate)
            buildRoute(startRoutePoint: startRoutePoint,
                       endRoutePoint: endRoutePoint,
                       transportType: .walking)
        } else {
            showIfLocationServicesDisabledAlert()
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let destinationEntity = view.annotation as! EntityForAnnotation
        selectedEntityCoordinates = destinationEntity.coordinate
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemGreen
        renderer.lineWidth = 7
        return renderer
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
        selectedEntityCoordinates = CLLocationCoordinate2D(latitude: selectedPlaceCoordinatesLat,
                                                           longitude: selectedPlaceCoordinatesLon)
        let selectedPlaceAddress = selectedOnSliderPlace?.address
        
        showAnnotation(coordinate: selectedEntityCoordinates,
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
        selectedEntityCoordinates = CLLocationCoordinate2D(latitude: selectedEventCoordinatesLat,
                                                           longitude: selectedEventCoordinatesLon)
        let selectedEventAddress = selectedOnSliderEvent?.place?.address
        
        showAnnotation(coordinate: selectedEntityCoordinates,
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

//MARK: - Alerts
extension MapScreenViewController {
    func showIfLocationServicesEnabledAlert() {
        showAlert(needСancellation: false,
                  with: "Службы геолокации включены.\nПерезапустите приложение",
                  and: "")
    }
    
    func showIfLocationServicesDisabledAlert() {
        showAlert(needСancellation: true,
                       with: "Службы геолокации отключены.",
                       and: "Вы хотите перейти в настройки и включить службы геолокации?",
                       completion: {
                        if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION_SERVICES") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                       })
    }
    
    func showIfCanNotBuildRoute() {
        showAlert(needСancellation: false,
                       with: "Маршрут до указанной точки не может быть построен!",
                       and: "Возможно отсутствует подключение к интернету или необходимо воспользоваться дальним видом транспорта.")
    }
}
