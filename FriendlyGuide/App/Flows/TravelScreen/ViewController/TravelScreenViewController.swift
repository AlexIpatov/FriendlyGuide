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
    var userSettings: UserSettings
    var requestFactory: RequestFactory
    lazy var currentCity: CityName? = userSettings.loadCurrentCity() {
        didSet {
            userSettings.saveCurrentCity(city: currentCity)
            reloadData()
        }
    }
    var places = [MocPlace]() {
        didSet {
            reloadData()
        }
    }
    var events = [Event]() {
        didSet {
            reloadData()
        }
    }
    var news = [MocNews]() {
        didSet {
            reloadData()
        }
    }
    // MARK: - Init
    init(requestFactory: RequestFactory,
         userSettings: UserSettings) {
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
        reloadData()
        mockFetch()
        requestData()
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
        let eventsFactory = requestFactory.makeGetEventsListFactory()
        eventsFactory.getEventsList { [ weak self] response in
            guard let self = self else {return}
            switch response {
            case .success(let events):
                self.events = events.results
            case .failure(let error):
                self.showAlert(with: "Error!",
                               and: error.localizedDescription)
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
        //    guard let currentCell = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        switch section {
        case .news, .events, .places:
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
extension TravelScreenViewController {
    func mockFetch() {
        news.append (MocNews(id: 33820, publicationDate: 1621939342, title: "ВКонтакте создала сервис, помогающий заботиться о домашних животных", images: Optional([MocImage(image: "https://kudago.com/media/images/news/97/fc/97fcd251036b9895e9b6cd910efc4425.jpg", source: MocSource(name: "shutterstock.com", link: ""))])))

        places.append (MocPlace(id: 157, coords: nil, title: "Музей современного искусства Эрарта", address: "29-я линия В. О., д. 2", subway: "Василеостровская, Приморская, Спортивная", images: Optional([MocImage(image: "https://kudago.com/media/images/place/83/20/83206505e69f74906bd996c42c4c0fc9.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00")), MocImage(image: "https://kudago.com/media/images/place/de/89/de89ef20687ea507e57107bfdf0e5735.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00")),MocImage(image: "https://kudago.com/media/images/place/20/80/2080284223698961282551f7c87f6685.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00")), MocImage(image: "https://kudago.com/media/images/place/bd/f6/bdf60df83d98b8337908752a85639de6.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00")), MocImage(image: "https://kudago.com/media/images/place/07/a4/07a4791f04d063dddb49abcdbfa6daa0.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00")), MocImage(image: "https://kudago.com/media/images/place/23/b4/23b46c37ccb99e5f942184f820d8a445.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00")), MocImage(image: "https://kudago.com/media/images/place/ef/96/ef96bbafdfcba465421cd98957cdb68b.jpg", source: MocSource(name: "vk.com", link: "https://vk.com/album-19191317_00"))])))

    }
}
