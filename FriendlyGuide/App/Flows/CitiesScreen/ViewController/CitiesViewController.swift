//
//  CitiesViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 25.05.2021.
//CityName(slug: "online", name: "Онлайн")

import UIKit

class CitiesViewController: UIViewController {
    // MARK: - UI components
    private lazy var citiesScreenView: CitiesView = {
        return CitiesView()
    }()
    // MARK: - Properties
    private var cities = [CityName]() {
        didSet {
            DispatchQueue.main.async {
            // Remove "online" from cities
                self.cities.removeAll {$0.slug == "online"}
                self.citiesScreenView.tableView.reloadData()
            }
        }
    }
    var requestFactory: RequestFactory
    weak var selectionDelegate: CitiesViewControllerDelegate?
    // MARK: - Init
    init(requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
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
        requestData()
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
    // MARK: - Button Methods
    @objc private func canсelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Request methods
    private func requestData() {
        let getCityNameFactory = requestFactory.makeGetCityNameFactory()
        getCityNameFactory.getCityNames { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch response {
                case .success(let cities):
                    self.cities = cities
                case .failure(let error):
                    self.showAlert(with: "Ошибка!",
                                   and: error.localizedDescription)
                }
            }
        }
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
        let selectedCity = cities[indexPath.row]
        selectionDelegate?.selectCity(city: selectedCity)
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - Actions
extension CitiesViewController {
    private func setupButtonsTargets() {
        citiesScreenView.canсelButton.addTarget(self,
                                                 action: #selector(canсelButtonTapped),
                                                 for: .touchUpInside)
    }
}
