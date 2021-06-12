//
//  DetailEventViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import UIKit
// Убрать
struct DescriptionForEntity: Hashable {
    var description: String?
    var firstSubtitle: String?
    var secondSubtitle: String?
    var boolSubtitle: Bool?
}
struct DetailEntity: Hashable {
    var images: [Image]?
    var title: String?
    var bodyText: String?
}
struct DetailData {
    var detailEntity: DetailEntity
    var description: DescriptionForEntity
    var shortPlace: EventPlace?
}
// TODO Поправить title
class DetailEventViewController: UIViewController {
    // MARK: - UI components
    private lazy var detailEventView: DetailEventView = {
        return DetailEventView()
    }()
    // MARK: - Properties
    var requestFactory: RequestFactory
    private var currentId: Int
    var detailData: DetailData? {
        didSet {
            DispatchQueue.main.async {
                self.title = self.detailData?.detailEntity.title
                self.reloadData()
            }
        }
    }
    var showMoreInfo: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    var currentSectionType: TravelSection
    // MARK: - Init
    init(requestFactory: RequestFactory,
         currentId: Int, currentSectionType: TravelSection) {
        self.requestFactory = requestFactory
        self.currentId = currentId
        self.currentSectionType = currentSectionType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        print(currentId)
        super.viewDidLoad()
        configureViewController()
        setupCollectionView()
        createDataSource()
        reloadData()
        requestData()
    }
    override func loadView() {
        view = detailEventView
    }
    // MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .white
    }
    // MARK: - CollectionView set up
    var dataSource: UICollectionViewDiffableDataSource<DetailSection, AnyHashable>?
    private func setupCollectionView() {
        detailEventView.collectionView.register(DetailDescriptionCell.self,
                                                forCellWithReuseIdentifier: DetailDescriptionCell.reuseId)
        detailEventView.collectionView.register(DetailImageCell.self,
                                                forCellWithReuseIdentifier: DetailImageCell.reuseId)
        detailEventView.collectionView.register(DetailMoreInfoCell.self,
                                                forCellWithReuseIdentifier: DetailMoreInfoCell.reuseId)
        detailEventView.collectionView.register(DetailPlaceForEventsCell.self,
                                                forCellWithReuseIdentifier: DetailPlaceForEventsCell.reuseId)
        detailEventView.collectionView.register(DetailSectionHeader.self,
                                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                withReuseIdentifier: DetailSectionHeader.reuseId)
        detailEventView.collectionView.delegate = self
    }
    // TODO убрать каст, сделать чище
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()
        guard let detailData = detailData else { return }
        snapshot.appendSections([.photos, .description, .moreInfo, .place])
        snapshot.appendItems([detailData.description], toSection: .description)
        if let images = detailData.detailEntity.images {
            snapshot.appendItems(images, toSection: .photos)
        }
        if showMoreInfo {
            snapshot.appendItems([detailData.detailEntity.bodyText], toSection: .moreInfo)
        }
        if detailData.shortPlace != nil {
            snapshot.appendItems([detailData.shortPlace], toSection: .place)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    // MARK: - Request data methods
    // Упростить
    private func requestData() {
        switch currentSectionType {
        case .events:
            let eventsFactory = requestFactory.makeGetEventDetailFactory()
            eventsFactory.getEventDetail(eventID: currentId) { [ weak self] response in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    switch response {
                    case .success(let event):
                        self.detailData = self.cellModel(from: event, type: .events)
                    case .failure(let error):
                        self.showAlert(with: "Error!",
                                       and: error.localizedDescription)
                    }
                }
            }
        case .places:
            let placeFactory = requestFactory.makeGetPlaceDetailFactory()
            placeFactory.load(id: currentId) { [ weak self] response in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    switch response {
                    case .success(let place):
                        self.detailData = self.cellModel(from: place, type: .places)
                    case .failure(let error):
                        self.showAlert(with: "Error!",
                                       and: error.localizedDescription)
                    }
                }
            }
        case .news:
            let newsFactory = requestFactory.makeGetNewsDetailFactory()
            newsFactory.load(id: currentId) { [ weak self] response in
                DispatchQueue.main.async {
                    guard let self = self else {return}
                    switch response {
                    case .success(let news):
                        self.detailData = self.cellModel(from: news, type: .news)
                    case .failure(let error):
                        self.showAlert(with: "Error!",
                                       and: error.localizedDescription)
                    }
                }
            }
        }
    }
}
// MARK: - Data Source
extension DetailEventViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DetailSection,
                                                        AnyHashable>(collectionView: detailEventView.collectionView,
                                                                     cellProvider: {(collectionView,
                                                                                     indexPath, item) -> UICollectionViewCell? in
                                                                        guard let section = DetailSection(rawValue: indexPath.section) else {
                                                                            fatalError("Unknown section kind")
                                                                        }
                                                                        switch section {
                                                                        case .photos:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: DetailImageCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        case .description:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: DetailDescriptionCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        case .moreInfo:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: DetailMoreInfoCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        case .place:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: DetailPlaceForEventsCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
                                                                        }
                                                                     })
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: DetailSectionHeader.reuseId,
                                                                                      for: indexPath) as? DetailSectionHeader else {
                fatalError("Can not create new section header")
            }
            sectionHeader.showMoreButton.addTarget(self,
                                                   action: #selector(self.showMoreButtonTapped),
                                                   for: .touchUpInside)
            return sectionHeader
        }
    }
}
// MARK: - UICollectionViewDelegate
extension DetailEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = DetailSection(rawValue: indexPath.section) else { return }
        switch section {
        case .photos:
            print("Добавить просмотр фоток")
        case .description:
            return
        case .moreInfo:
            showMoreButtonTapped()
        case .place:
            return
        }
    }
}
// MARK: - Actions
extension DetailEventViewController {
    @objc func showMoreButtonTapped() {
        showMoreInfo = showMoreInfo ? false : true
    }
}
    //MARK: - Cell Model For Event
extension DetailEventViewController {
    func cellModel<U>(from entity: U, type: TravelSection) -> DetailData? {
        let descriptionForEntity: DescriptionForEntity
        let detailEntity: DetailEntity
        let shortPlace: EventPlace?
        switch type {
        case .events:
            guard  let entity: EventDetail = entity as? EventDetail else { return nil}
            descriptionForEntity = DescriptionForEntity(description: entity.description,
                                                              firstSubtitle: entity.price,
                                                              secondSubtitle: "",
                                                              boolSubtitle: entity.isFree)
             detailEntity =  DetailEntity(images: entity.images,
                                              title: entity.title,
                                              bodyText: entity.bodyText)
              shortPlace = entity.place
        case .places:
            guard  let entity: PlaceDetail = entity as? PlaceDetail else { return nil}
             descriptionForEntity = DescriptionForEntity(description: entity.description,
                                                                                         firstSubtitle: entity.timetable,
                                                                                         boolSubtitle: entity.isClosed)
              detailEntity =  DetailEntity(images: entity.images,
                                              title: entity.title,
                                              bodyText: entity.bodyText)
              shortPlace = EventPlace(title: entity.title,
                                          address: entity.address,
                                          phone: entity.phone,
                                          subway: entity.subway,
                                          siteURL: entity.siteUrl,
                                          isClosed: entity.isClosed,
                                          coords: entity.coords)
        case .news:
            guard  let entity: NewsDetail = entity as? NewsDetail else { return nil}
             descriptionForEntity = DescriptionForEntity(description: entity.description,
                                                             secondSubtitle: entity.publicationDate.description)
             detailEntity = DetailEntity(images: entity.images,
                                             title: entity.title,
                                             bodyText: entity.bodyText)
             shortPlace = entity.place
        }

        return DetailData(detailEntity: detailEntity,
                          description: descriptionForEntity,
                          shortPlace: shortPlace)
    }
}
