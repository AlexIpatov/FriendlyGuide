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
    private var locationManager = LocationManager.instance
    private var dataProvider: MapDataProvider
    private var requestFactory: RequestFactory
    
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
    
    private var selectedOnSliderPlaceOrEvent: EntityForAnnotation?
    private var selectedEntityCoordinates = CLLocationCoordinate2D()
    
    private var allEntitiesForAnnotationArray: [EntityForAnnotation] = []
    private var placeEntitiesForAnnotationArray: [EntityForAnnotation] = []
    private var eventEntitiesForAnnotationArray: [EntityForAnnotation] = []
    private var cities: [CityName] = []
            
    //MARK: - Slider properties
    private let transition = SliderTransition()
    
    //MARK: - Init
    init(requestFactory: RequestFactory,
         dataProvider: MapDataProvider) {
        self.requestFactory = requestFactory
        self.dataProvider = dataProvider
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
        configureLocationManager()
        configureMap()
        configureButtons()
        loadDataFromNetwork()
        loadCitiesNamesFromNetwork()
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
                case .success((let events, let places)):
                    self.createAllEntitiesForAnnotationArray(placesArray: places, eventsArray: events)
                    self.showAllAnnotations()
                    self.configureFindPlaceOrEventButtonWhenDataLoaded()
                case .failure(let error):
                    self.showAlert(with: "Ошибка загрузки данных о местах и событиях",
                                   and: error.localizedDescription)
                }
            }
        }
    }
    
    private func loadCitiesNamesFromNetwork() {
        let getCityNameFactory = requestFactory.makeGetCityNameFactory()
        getCityNameFactory.load { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch response {
                case .success(let cities):
                    self.cities = cities
                    self.cities.removeAll {$0.slug == "online"}
                case .failure(let error):
                    self.showAlert(with: "Ошибка получения названий городов",
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
        mapScreenView.reloadDataButton.addTarget(self, action: #selector(tapReloadDataButton(_:)),
                                                 for: .touchUpInside)
    }
    @objc func tapReloadDataButton(_ sender: UIButton) {
        loadDataFromNetwork()
    }
    
    //MARK: - FindPlaceOrEventButton
    func configureFindPlaceOrEventButton() {
        mapScreenView.findPlaceOrEventButton.addTarget(self, action: #selector(tapFindPlaceOrEventButton(_:)),
                                                       for: .touchUpInside)
    }
    @objc func tapFindPlaceOrEventButton(_ sender: UIButton) {
        showOnMapSliderViewController()
    }
    
    func showOnMapSliderViewController() {
        let child = OnMapSliderViewController(
            allPlaces: placeEntitiesForAnnotationArray,
            allEvents: eventEntitiesForAnnotationArray,
            initialSegmentIndex: initialSegmentIndex ?? 0)
        child.transitioningDelegate = transition
        child.modalPresentationStyle = .custom
        child.placeOrEventDelegate = self
        self.present(child, animated: true, completion: nil)
    }
    
    func configureFindPlaceOrEventButtonWhenDataLoaded() {
        mapScreenView.findPlaceOrEventButton.tintColor = .systemBlue
        mapScreenView.findPlaceOrEventButton.isEnabled = true
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
            showRoute(startRoutePoint: startRoutePoint,
                       endRoutePoint: endRoutePoint,
                       transportType: .walking)
        } else {
            showIfLocationServicesDisabledAlert()
        }
    }
    
    func showRoute(startRoutePoint: MKPlacemark,
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
            if let routeBoundsRect = response.routes.first?.polyline.boundingMapRect {
                let insets = UIEdgeInsets(top: 40.0, left: 40.0, bottom: 40.0, right: 40.0)
                self.mapScreenView.mapView.setVisibleMapRect(routeBoundsRect, edgePadding: insets, animated: true)
            }
        }
    }
    
    //MARK: - СlearRouteButton
    func configureСlearRouteButton() {
        mapScreenView.clearRouteButton.addTarget(self, action: #selector(tapClearRouteButton(_:)), for: .touchUpInside)
    }
    @objc func tapClearRouteButton(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            mapScreenView.mapView.removeOverlays(mapScreenView.mapView.overlays)
        } else {
            showIfLocationServicesDisabledAlert()
        }
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
        if CLLocationManager.locationServicesEnabled() {
            if mapScreenView.startTrackingLocationButton.tag == 0 {
                // Run tracking
                setStartTrackingLocationButtonToStatusTapped()
                locationManager.startUpdatingLocationInLocationManager()
            } else if mapScreenView.startTrackingLocationButton.tag == 1 {
                // Stop tracking
                setStartTrackingLocationButtonToStatusUntapped()
                locationManager.stopUpdatingLocationInLocationManager()
            }
        } else {
            showIfLocationServicesDisabledAlert()
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
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocationInLocationManager()
            if mapScreenView.startTrackingLocationButton.tag == 1 {
                setStartTrackingLocationButtonToStatusUntapped()
            }
            locationManager.requestLocationInLocationManager()
            configureCurrentCoordinateLatLonLabels()
        } else {
            showIfLocationServicesDisabledAlert()
        }
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
            mapScreenView.buildingRouteButton.tintColor = .systemGray4
            mapScreenView.clearRouteButton.tintColor = .systemGray4
            mapScreenView.startTrackingLocationButton.tintColor = .systemGray4
            mapScreenView.showCurrentLocationButton.tintColor = .systemGray4
        }
    }
    
    //MARK: - Annotations
    func showAnnotation(coordinate: CLLocationCoordinate2D,
                        title: String,
                        subtitle: String,
                        color: UIColor,
                        cityName: String) {
        let entityForAnnotation = EntityForAnnotation(coordinate: coordinate,
                                                      title: title,
                                                      subtitle: subtitle,
                                                      color: color,
                                                      cityName: cityName)
        currentRegion = makeRegionForDisplay(center: coordinate)
        mapScreenView.mapView.addAnnotation(entityForAnnotation)
        showRegion(region: currentRegion)
    }
    
    func showAllAnnotations() {
        mapScreenView.mapView.addAnnotations(allEntitiesForAnnotationArray)
    }
    
    func createAllEntitiesForAnnotationArray(placesArray: [Place], eventsArray: [Event]) {
        allEntitiesForAnnotationArray = []
        createArrayFromPlaceEntitiesForAnnotation(placesArray: placesArray)
        createArrayFromEventEntitiesForAnnotation(eventsArray: eventsArray)
        allEntitiesForAnnotationArray.append(contentsOf: placeEntitiesForAnnotationArray)
        allEntitiesForAnnotationArray.append(contentsOf: eventEntitiesForAnnotationArray)
    }
    
    func createArrayFromPlaceEntitiesForAnnotation(placesArray: [Place]) {
        placeEntitiesForAnnotationArray = []
        for place in placesArray {
            if let placeCoordinatesLat = place.coords?.lat,
               let placeCoordinatesLon = place.coords?.lon {
                let placeCoordinate = CLLocationCoordinate2D(latitude: placeCoordinatesLat,
                                                             longitude: placeCoordinatesLon)
                let city = cities.filter{$0.slug == place.location}.first
                let cityNameAndSlug = "(\(place.location ?? "")) \(city?.name ?? "")"

                let entityForAnnotationFromPlace = EntityForAnnotation(coordinate: placeCoordinate,
                                                                       title: place.title,
                                                                       subtitle: place.address,
                                                                       color: .systemGreen,
                                                                       cityName: cityNameAndSlug)
                placeEntitiesForAnnotationArray.append(entityForAnnotationFromPlace)
            }
        }
    }
    
    func createArrayFromEventEntitiesForAnnotation(eventsArray: [Event]) {
        eventEntitiesForAnnotationArray = []
        for event in eventsArray {
            if let eventCoordinatesLat = event.place?.coords?.lat,
               let eventCoordinatesLon = event.place?.coords?.lon {
                let eventCoordinate = CLLocationCoordinate2D(latitude: eventCoordinatesLat,
                                                             longitude: eventCoordinatesLon)
                let city = cities.filter {$0.slug == event.place?.location}.first
                let cityNameAndSlug = "(\(event.place?.location ?? "")) \(city?.name ?? "")"
                
                let entityForAnnotationFromEvent = EntityForAnnotation(coordinate: eventCoordinate,
                                                                       title: event.title,
                                                                       subtitle: event.place?.address,
                                                                       color: .systemOrange,
                                                                       cityName: cityNameAndSlug)
                eventEntitiesForAnnotationArray.append(entityForAnnotationFromEvent)
            }
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
            showRoute(startRoutePoint: startRoutePoint,
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
    func selectPlaceOrEvent(selectedPlaceOrEvent: EntityForAnnotation) {
        selectedOnSliderPlaceOrEvent = selectedPlaceOrEvent
        guard let selectedPlaceOrEventCoordinatesLat = selectedOnSliderPlaceOrEvent?.coordinate.latitude,
              let selectedPlaceOrEventCoordinatesLon = selectedOnSliderPlaceOrEvent?.coordinate.longitude,
              let selectedPlaceOrEventTitle = selectedOnSliderPlaceOrEvent?.title else {
            return
        }
        selectedEntityCoordinates = CLLocationCoordinate2D(latitude: selectedPlaceOrEventCoordinatesLat,
                                                           longitude: selectedPlaceOrEventCoordinatesLon)
        let selectedPlaceOrEventAddress = selectedOnSliderPlaceOrEvent?.subtitle
        let selectedPlaceOrEventAnnotationColor = selectedOnSliderPlaceOrEvent?.color
        let selectedPlaceOrEventAnnotationCityName = selectedOnSliderPlaceOrEvent?.cityName
        
        showAnnotation(coordinate: selectedEntityCoordinates,
                       title: selectedPlaceOrEventTitle,
                       subtitle: selectedPlaceOrEventAddress ?? "",
                       color: selectedPlaceOrEventAnnotationColor ?? .black,
                       cityName: selectedPlaceOrEventAnnotationCityName ?? "")
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
