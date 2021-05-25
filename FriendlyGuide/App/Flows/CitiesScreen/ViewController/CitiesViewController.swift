//
//  CitiesViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//

import UIKit
// TODO - Убрать мок структуру перевести таблицу на реальные данные когда будет готова сеть
struct MocCity: Hashable {
    var name: String
    var slug: String
}

class CitiesViewController: UIViewController {
    // MARK: - UI components
    private lazy var citiesScreenView: CitiesView = {
        return CitiesView()
    }()
    
    // MARK: - Properties
    private var cities = [MocCity(name: "Москва",
                                  slug: "msk"),
                          MocCity(name: "Санкт - Петербург",
                                  slug: "спб")] {
        didSet {
            citiesScreenView.tableView.reloadData()
        }
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupTableView()
        setupButtonsTargets()
        
    }
    
    override func loadView() {
        view = citiesScreenView
    }
    
    //MARK: -  Methods
    func configureViewController() {
        self.title = ""
    }
    
    // MARK: - Setup TableView
    private func setupTableView() {
        citiesScreenView.tableView.register(CitiesCell.self,
                                            forCellReuseIdentifier: CitiesCell.reuseId)
        citiesScreenView.tableView.delegate = self
        citiesScreenView.tableView.dataSource = self
    }
    
    @objc private func selectCityButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func canсelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitiesCell.reuseId,
                                                       for: indexPath) as? CitiesCell else {return UITableViewCell()}
        
        let selectedCity = cities[indexPath.row]
        cell.configure(with: selectedCity)
        return cell
    }
}
// MARK: - UITableViewDelegate
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
//MARK: - Actions
extension CitiesViewController {
    private func setupButtonsTargets() {
        citiesScreenView.selectCityButton.addTarget(self,
                                                    action: #selector(selectCityButtonTapped),
                                                    for: .touchUpInside)
        citiesScreenView.canсelButton.addTarget(self,
                                                 action: #selector(canсelButtonTapped),
                                                 for: .touchUpInside)
    }
}
