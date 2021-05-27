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
    private var allPlacesAndEvents = [MocPlacesAndEvents(name: "Калуга",
                                  slug: "klg"),
                          MocPlacesAndEvents(name: "Воронеж",
                                  slug: "vrn"),
                          MocPlacesAndEvents(name: "Саратов",
                                  slug: "srt")] {
        didSet {
            onMapSliderView.placesAndEventsTableView.reloadData()
        }
    }
    private var filteredPlacesAndEvents: [MocPlacesAndEvents] = []
    
    //MARK: - Properties for search
    private var searchText: String {
        onMapSliderView.searchTextField.text ?? ""
    }
    
    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
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
        filteredPlacesAndEvents = []
        for placeOrEvent in allPlacesAndEvents {
            if placeOrEvent.name.lowercased().contains(searchText.lowercased()) {
                filteredPlacesAndEvents.append(placeOrEvent)
            }
        }
        onMapSliderView.placesAndEventsTableView.reloadData()
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
}
// MARK: - UITableViewDataSource
extension OnMapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
            return allPlacesAndEvents.count
        } else {
            return filteredPlacesAndEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OnMapSliderTableViewCell.reuseId,
                                                       for: indexPath) as? OnMapSliderTableViewCell else {return UITableViewCell()}
        if onMapSliderView.searchTextField.text?.isTrimmedEmpty ?? true {
            let selectedCity = allPlacesAndEvents[indexPath.row]
            cell.configure(with: selectedCity)
            return cell
        } else {
            let selectedCity = filteredPlacesAndEvents[indexPath.row]
            cell.configure(with: selectedCity)
            return cell
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



