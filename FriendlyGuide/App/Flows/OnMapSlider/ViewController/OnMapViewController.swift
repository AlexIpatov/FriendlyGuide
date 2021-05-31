//
//  OnMapViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 26.05.2021.
//

import UIKit

// TODO - Убрать мок структуру перевести таблицу на реальные данные когда будет готова сеть
struct MocPlacesAndEvents: Hashable {
    var name: String
    var slug: String
}

class OnMapViewController: UIViewController {
    // MARK: - UI components
    private lazy var onMapSliderView: OnMapSliderView = {
        return OnMapSliderView()
    }()
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    private var allPlaces = [
        MocPlace(id: 123, coords: nil, title: "Музей", address: "", subway: "", images: nil),
        MocPlace(id: 234, coords: nil, title: "Театр", address: "", subway: "", images: nil),
        MocPlace(id: 345, coords: nil, title: "Кино", address: "", subway: "", images: nil),
        MocPlace(id: 111, coords: nil, title: "Если одинаковое поле", address: "", subway: "", images: nil)
    ] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }
    
    private var allEvents = [
        MocEvent(id: 456, dates: [], title: "Выступление клоунов", price: "1500", images: nil),
        MocEvent(id: 567, dates: [], title: "Чемпионат мира по боксу", price: "200", images: nil),
        MocEvent(id: 678, dates: [], title: "Выставка кошек", price: "600", images: nil),
        MocEvent(id: 222, dates: [], title: "Если одинаковое поле", price: "600", images: nil)
    ] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }
    
    private var filteredPlacesAndEvents: [MocPlacesAndEvents] = []
    
    private var filteredPlaces: [MocPlace] = []
    private var filteredEvents: [MocEvent] = []
    
    private var selectedSegmentIndex: Int {
        self.onMapSliderView.sourceSelectionSegmentedControl.selectedSegmentIndex
    }
    
    //MARK: - Properties for search
    private var searchText: String {
        onMapSliderView.searchTextField.text ?? ""
    }
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureSourceSelectionSegmentedControl()
        configureSearchTextField()
        configureButtons()
        configureKeyboard()
    }
    
    override func loadView() {
        view = onMapSliderView
    }
    
    // MARK: - Configuration Methods
    private func configureViewController() {
        view.backgroundColor = .white
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
extension OnMapViewController: UITableViewDataSource {
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
                                                       for: indexPath) as? OnMapSliderTableViewCell else {return UITableViewCell()}
        if selectedSegmentIndex == 0 {
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                let selectedPlace = allPlaces[indexPath.row]
                cell.configure(with: selectedPlace)
                return cell
            } else {
                let selectedCity = filteredPlaces[indexPath.row]
                cell.configure(with: selectedCity)
                return cell
            }
        } else {
            if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
                let selectedEvent = allEvents[indexPath.row]
                cell.configure(with: selectedEvent)
                return cell
            } else {
                let selectedCity = filteredEvents[indexPath.row]
                cell.configure(with: selectedCity)
                return cell
            }
        }
    }
}
// MARK: - UITableViewDelegate
extension OnMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Keyboard configuration
extension OnMapViewController {
        func configureKeyboard() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardByTap))
            onMapSliderView.headerView.addGestureRecognizer(tapGesture)
        }
    
        @objc func hideKeyboardByTap() {
            onMapSliderView.endEditing(true)
        }
}



