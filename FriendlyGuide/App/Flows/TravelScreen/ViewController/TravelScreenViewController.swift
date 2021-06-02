//
//  TravelScreenViewController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit

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
            requestData()
        }
    }
    var places = [Places]()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupCollectionView()
        createDataSource()
        requestData()
        addTargets()
    }
    override func loadView() {
        view = travelScreenView
    }
    // MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .white
        self.title = "Путешествие"
    }
    // MARK: - CollectionView set up
    var dataSource: UICollectionViewDiffableDataSource<TravelSection, AnyHashable>?
    private func setupCollectionView() {
        travelScreenView.collectionView.register(SelectCityCell.self,
                                                 forCellWithReuseIdentifier: SelectCityCell.reuseId)
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
        snapshot.appendSections([.city, .events, .places, .news])
        snapshot.appendItems(events, toSection: .events)
        snapshot.appendItems(places, toSection: .places)
        snapshot.appendItems(news, toSection: .news)
        snapshot.appendItems([currentCity], toSection: .city)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    // MARK: - Request data methods
    private func requestData() {
        //TODO сделать норм дату 
        self.dataProvider.getData(cityTag: currentCity?.slug ?? "",
                                  actualSince: String(Date().timeIntervalSince1970),
                                  showingSince: String(Date().timeIntervalSince1970)) { [weak self] response in
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
                                                                        case .city:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: SelectCityCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
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
        guard let section = TravelSection(rawValue: indexPath.section) else { return }
        switch section {
        case .events:
            guard let currentCell = self.dataSource?.itemIdentifier(for: indexPath) as? Event else { return }
            let detailVC = DetailEventViewController(requestFactory: requestFactory, currentId: currentCell.id)
            detailVC.modalPresentationStyle = .fullScreen
            present(detailVC, animated: true, completion: nil)
        case .news, .places:
            print("tapped")
        case .city:
            let cityVC = CitiesViewController(requestFactory: requestFactory)
            cityVC.modalPresentationStyle = .fullScreen
            cityVC.selectionDelegate = self
            present(cityVC, animated: true, completion: nil)
        }
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
        travelScreenView.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    @objc func refreshData() {
        travelScreenView.refreshControl.beginRefreshing()
        requestData()
        travelScreenView.refreshControl.endRefreshing()
    }
}
// MARK: - Mock structs
struct MocPlace: Codable, Hashable {
    let id: Int
    let coords: MocCoords?
    let title, address, subway: String
    let images: [MocImage]?
}
struct MocEvent: Codable, Hashable {
    let id: Int
    let dates: [MocDateElement]
    let title, price: String
    let images: [MocImage]?
}

struct MocNews: Codable, Hashable {
    let id: Int
    let publicationDate: Int
    let title: String
    let images: [MocImage]?
    enum CodingKeys: String, CodingKey {
        case id
        case publicationDate = "publication_date"
        case title
        case images
    }
}
struct MocImage: Codable, Hashable {
    let image: String
    let source: MocSource
}
struct MocSource: Codable, Hashable {
    let name: String
    let link: String
}
struct MocDateElement: Codable, Hashable {
    let start, end: Int
}
struct MocCoords: Codable, Hashable {
    let lat, lon: Double
}
