//
//  TravelScreenViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import CoreLocation

class TravelScreenViewController: UIViewController {
    // MARK: - UI components
    private lazy var travelScreenView: TravelScreenView = {
        return TravelScreenView()
    }()
    // MARK: - Properties
    var requestFactory: RequestFactory
    var dataProvider: DataProvider
    var userSettings: UserSettings
    lazy var currentCity: CityName? = userSettings.loadCurrentCity() {
        didSet {
            userSettings.saveCurrentCity(city: currentCity)
            setCityTitle() 
            requestData()
        }
    }
    var places = [Place]()
    var events = [Event]()
    var news = [News]()
    // MARK: - Init
    init(requestFactory: RequestFactory,
         userSettings: UserSettings,
         dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.requestFactory = requestFactory
        self.userSettings = userSettings
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewController Lifecycle
    override func loadView() {
        view = travelScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupCollectionView()
        createDataSource()
        requestData()
        addTargets()
        setCityTitle()
        configNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    // MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .white
        self.title = "Путешествие"
    }
    // MARK: - Config navigation bar
    private func configNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: travelScreenView.cityNameView)
    }
    private func setCityTitle() {
        guard let cityTitle = currentCity?.name else {return}
        travelScreenView.cityNameView.setTitle(cityTitle, for: .normal)
    }
    // MARK: - CollectionView set up
    var dataSource: UICollectionViewDiffableDataSource<TravelSection, AnyHashable>?
    private func setupCollectionView() {
        travelScreenView.collectionView.register(EventCell.self,
                                                 forCellWithReuseIdentifier: EventCell.reuseId)
        travelScreenView.collectionView.register(PlaceCell.self,
                                                 forCellWithReuseIdentifier: PlaceCell.reuseId)
        travelScreenView.collectionView.register(NewsCell.self,
                                                 forCellWithReuseIdentifier: NewsCell.reuseId)
        travelScreenView.collectionView.register(SectionHeader.self,
                                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                 withReuseIdentifier: SectionHeader.reuseId)
        travelScreenView.collectionView.delegate = self
    }
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<TravelSection, AnyHashable>()
        snapshot.appendSections([.events, .places, .news])
        snapshot.appendItems(events, toSection: .events)
        snapshot.appendItems(places, toSection: .places)
        snapshot.appendItems(news, toSection: .news)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    // MARK: - Request data methods
    private func requestData() {
        let currentDate = String(Date().timeIntervalSince1970)
        self.dataProvider.getData(cityTag: self.currentCity?.slug ?? "",
                                  actualSince: currentDate,
                                  showingSince: currentDate) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch response {
                case .success((let events, let news, let places)):
                    self.events = events
                    self.news = news
                    self.places = places
                    self.reloadData()
                case .failure(let error):
                    self.showAlert(with: "Ошибка!", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Data Source
extension TravelScreenViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<TravelSection,
                                                        AnyHashable>(collectionView: travelScreenView.collectionView,
                                                                     cellProvider: {(collectionView,
                                                                                     indexPath, item) -> UICollectionViewCell? in
                                                                        guard let section = TravelSection(rawValue: indexPath.section) else {
                                                                            fatalError("Unknown section kind")
                                                                        }
                                                                        switch section {
                                                                        case .events:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: EventCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        case .places:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: PlaceCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        case .news:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: NewsCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        }
                                                                     })
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: SectionHeader.reuseId,
                                                                                      for: indexPath) as? SectionHeader else {
                fatalError("Can not create new section header")
            }
            guard let section = TravelSection(rawValue: indexPath.section) else { fatalError("Unknown section kind") }
            sectionHeader.configure(text: section.description(),
                                    font: .boldTitleFont(),
                                    textColor: .gray)
            return sectionHeader
        }
    }
}
// MARK: - UICollectionViewDelegate
extension TravelScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = TravelSection(rawValue: indexPath.section),
              let currentCell = self.dataSource?.itemIdentifier(for: indexPath) as? Identifiable else { return }
        let detailVC = DetailEventViewController(requestFactory: requestFactory,
                                                 currentId: currentCell.id,
                                                 currentSectionType: section)
        detailVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension TravelScreenViewController: CitiesViewControllerDelegate {
    func selectCity(city: CityName) {
        currentCity = city
    }
}
// MARK: - Actions
extension TravelScreenViewController {
    func addTargets() {
        travelScreenView.refreshControl.addTarget(self, action: #selector(refreshData),
                                                  for: .valueChanged)
        travelScreenView.cityNameView.addTarget(self, action: #selector(cityNameViewTapped),
                                                for: .touchUpInside)
    }
    @objc func refreshData() {
        travelScreenView.refreshControl.beginRefreshing()
        requestData()
        travelScreenView.refreshControl.endRefreshing()
    }
    @objc func cityNameViewTapped() {
        let cityVC = CitiesViewController(requestFactory: requestFactory)
        cityVC.modalPresentationStyle = .fullScreen
        cityVC.selectionDelegate = self
        present(cityVC, animated: true, completion: nil)
    }
}
