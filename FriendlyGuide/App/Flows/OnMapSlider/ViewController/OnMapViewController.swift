//
//  OnMapViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit

//MARK: - Protocol
protocol OnMapViewControllerDelegate: AnyObject {
    func selectPlace(selectedPlace: Place)
    func selectEvent(selectedEvent: Event)
    func saveSelectedSegmentIndex(index: Int)
}

class OnMapSliderViewController: UIViewController {
    // MARK: - UI components
    private lazy var onMapSliderView: OnMapSliderView = {
        return OnMapSliderView()
    }()
    
    //MARK: - Init
    init(initialSegmentIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.initialSegmentIndex = initialSegmentIndex
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private var allPlaces = [
        Place(id: 123, title: "Государственный музей А.С.Пушкина", address: "Хрущёвский пер., 2/12", coords: Coordinates(lat: 55.743548, lon: 37.597612), subway: "Кропоткинская", images: []),
        Place(id: 234, title: "Государственный академический Большой театр России", address: "Театральная площадь, 1", coords: Coordinates(lat: 55.760221, lon: 37.618561), subway: "Театральная", images: []),
        Place(id: 345, title: "Радуга Кино", address: "просп. Андропова, 8", coords: Coordinates(lat: 55.695720, lon: 37.665070), subway: "Технопарк", images: []),
        Place(id: 111, title: "Если одинаковое поле без координат", address: "", coords: nil, subway: "", images: [])
    ] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }

    private var allEvents = [
        Event(id: 456, title: "Выступление клоунов", dates: [], images: [], place: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 55.719438, lon: 37.627026))),
        Event(id: 567, title: "Чемпионат мира по боксу", dates: [], images: [], place: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 55.714312, lon: 37.567163))),
        Event(id: 678, title: "Выставка кошек", dates: [], images: [], place: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 55.798555, lon: 37.670538))),
        Event(id: 222, title: "Если одинаковое поле без координат", dates: [], images: [], place: nil)
    ] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }
    private var filteredPlaces: [Place] = []
    private var filteredEvents: [Event] = []
    
    private var selectedSegmentIndex: Int {
        self.onMapSliderView.sourceSelectionSegmentedControl.selectedSegmentIndex
    }
    private var initialSegmentIndex: Int?
    weak var placeOrEventDelegate: OnMapViewControllerDelegate?
    
    //MARK: - Properties for search
    private var searchText: String {
        onMapSliderView.searchTextField.text ?? ""
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
            if place.title.lowercased().contains(searchText.lowercased()) {
                filteredPlaces.append(place)
            }
        }
    }
    
    private func prepareFilteredEvents() {
        filteredEvents = []
        for event in allEvents {
            if event.title.lowercased().contains(searchText.lowercased()) {
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
            var selectedPlace = Place(id: 0, title: "", address: "", coords: nil, subway: "", images: [])
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                selectedPlace = allPlaces[indexPath.row]
            } else {
                selectedPlace = filteredPlaces[indexPath.row]
            }
            placeOrEventDelegate?.selectPlace(selectedPlace: selectedPlace)
            placeOrEventDelegate?.saveSelectedSegmentIndex(index: selectedSegmentIndex)
        } else {
            var selectedEvent = Event(id: 0, title: "", dates: [], images: [], place: nil)
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                selectedEvent = allEvents[indexPath.row]
            } else {
                selectedEvent = filteredEvents[indexPath.row]
            }
            placeOrEventDelegate?.selectEvent(selectedEvent: selectedEvent)
            placeOrEventDelegate?.saveSelectedSegmentIndex(index: selectedSegmentIndex)
        }
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
