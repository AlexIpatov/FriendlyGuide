//
//  OnMapViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit
import CoreLocation

//MARK: - Protocol
protocol OnMapViewControllerDelegate: AnyObject {
    func selectPlaceOrEvent(selectedPlaceOrEvent: EntityForAnnotation)
    func saveSelectedSegmentIndex(index: Int)
}

class OnMapSliderViewController: UIViewController {
    // MARK: - UI components
    private lazy var onMapSliderView: OnMapSliderView = {
        return OnMapSliderView()
    }()
    
    //MARK: - Properties
    private var allPlaces: [EntityForAnnotation] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }
    private var allEvents: [EntityForAnnotation] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }
    private var filteredPlaces: [EntityForAnnotation] = []
    private var filteredEvents: [EntityForAnnotation] = []
    
    private var selectedSegmentIndex: Int {
        self.onMapSliderView.sourceSelectionSegmentedControl.selectedSegmentIndex
    }
    private var initialSegmentIndex: Int?
    weak var placeOrEventDelegate: OnMapViewControllerDelegate?
    
    //MARK: - Properties for search
    private var searchText: String {
        onMapSliderView.searchTextField.text ?? ""
    }
    
    //MARK: - Init
    init(allPlaces: [EntityForAnnotation],
         allEvents: [EntityForAnnotation],
         initialSegmentIndex: Int) {
        self.allPlaces = allPlaces
        self.allEvents = allEvents
        self.initialSegmentIndex = initialSegmentIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController LifeCycle
    override func loadView() {
        view = onMapSliderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureSourceSelectionSegmentedControl()
        configureSearchTextField()
        configureButtons()
        configureKeyboard()
    }
    
    // MARK: - Configuration Methods
    private func configureViewController() {
        view.backgroundColor = .white
        self.onMapSliderView.sourceSelectionSegmentedControl.selectedSegmentIndex = initialSegmentIndex ?? 0
    }
    private func configureTableView() {
        onMapSliderView.placesAndEventsTableView.register(OnMapSliderTableViewCell.self,
                                                          forCellReuseIdentifier: OnMapSliderTableViewCell.reuseId)
        onMapSliderView.placesAndEventsTableView.delegate = self
        onMapSliderView.placesAndEventsTableView.dataSource = self
    }
    
    private func configureSearchTextField() {
        onMapSliderView.searchTextField.addTarget(self, action: #selector(searchTextFieldDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func searchTextFieldDidChanged(_ sender: UIButton) {
        switch selectedSegmentIndex {
        case 0:
            prepareFilteredPlaces()
            break;
        case 1:
            prepareFilteredEvents()
            break;
        default:
            break;
        }
        onMapSliderView.placesAndEventsTableView.reloadData()
    }
    
    private func prepareFilteredPlaces() {
        filteredPlaces = []
        for place in allPlaces {
            guard let title = place.title else { return }
            if title.lowercased().contains(searchText.lowercased()) {
                filteredPlaces.append(place)
            }
        }
    }
    
    private func prepareFilteredEvents() {
        filteredEvents = []
        for event in allEvents {
            guard let title = event.title else { return }
            if title.lowercased().contains(searchText.lowercased()) {
                filteredEvents.append(event)
            }
        }
    }
    
    private func configureButtons() {
        configureRemoveSliderButton()
    }
    
    private func configureRemoveSliderButton() {
        onMapSliderView.removeSliderButton.addTarget(self, action: #selector(tapRemoveSliderButton(_:)), for: .touchUpInside)
    }
    
    @objc func tapRemoveSliderButton(_ sender: UIButton) {
        placeOrEventDelegate?.saveSelectedSegmentIndex(index: selectedSegmentIndex)
        dismiss(animated: true, completion: nil)
    }
    
    private func configureSourceSelectionSegmentedControl() {
        onMapSliderView.sourceSelectionSegmentedControl.addTarget(self, action: #selector(selectSource(_:)), for: .valueChanged)
    }
    
    @objc func selectSource(_ sender: UISegmentedControl) {
        switch selectedSegmentIndex {
        case 0:
            prepareFilteredPlaces()
            onMapSliderView.searchTextField.placeholder = "Введите место для поиска"
            break;
        case 1:
            prepareFilteredEvents()
            onMapSliderView.searchTextField.placeholder = "Введите событие для поиска"
            break;
        default:
            break;
        }
        onMapSliderView.placesAndEventsTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension OnMapSliderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSegmentIndex == 0 {
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                return allPlaces.count
            } else {
                return filteredPlaces.count
            }
        } else {
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                return allEvents.count
            } else {
                return filteredEvents.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnMapSliderTableViewCell.reuseId,
                                                       for: indexPath) as? OnMapSliderTableViewCell else {
            return UITableViewCell()
        }
        if selectedSegmentIndex == 0 {
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                let selectedPlace = allPlaces[indexPath.row]
                cell.configure(with: selectedPlace)
                return cell
            } else {
                let selectedPlace = filteredPlaces[indexPath.row]
                cell.configure(with: selectedPlace)
                return cell
            }
        } else {
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                let selectedEvent = allEvents[indexPath.row]
                cell.configure(with: selectedEvent)
                return cell
            } else {
                let selectedEvent = filteredEvents[indexPath.row]
                cell.configure(with: selectedEvent)
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension OnMapSliderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSegmentIndex == 0 {
            var selectedPlace = EntityForAnnotation(coordinate: CLLocationCoordinate2D(), title: "", subtitle: "", color: .black)
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                selectedPlace = allPlaces[indexPath.row]
            } else {
                selectedPlace = filteredPlaces[indexPath.row]
            }
            placeOrEventDelegate?.selectPlaceOrEvent(selectedPlaceOrEvent: selectedPlace)
        } else {
            var selectedEvent = EntityForAnnotation(coordinate: CLLocationCoordinate2D(), title: "", subtitle: "", color: .black)
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                selectedEvent = allEvents[indexPath.row]
            } else {
                selectedEvent = filteredEvents[indexPath.row]
            }
            placeOrEventDelegate?.selectPlaceOrEvent(selectedPlaceOrEvent: selectedEvent)
        }
        placeOrEventDelegate?.saveSelectedSegmentIndex(index: selectedSegmentIndex)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Keyboard configuration
extension OnMapSliderViewController {
    func configureKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap))
        onMapSliderView.headerView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboardByTap() {
        onMapSliderView.endEditing(true)
    }
}
