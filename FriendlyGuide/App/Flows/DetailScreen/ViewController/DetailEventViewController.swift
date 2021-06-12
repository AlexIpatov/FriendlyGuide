//
//  DetailEventViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import UIKit
// TODO Поправить title
class DetailEventViewController: UIViewController {
    // MARK: - UI components
    private lazy var detailEventView: DetailEventView = {
        return DetailEventView()
    }()
    // MARK: - Properties
    var requestFactory: RequestFactory
    private var currentId: Int
    var entity: EventDetail? {
        didSet {
            DispatchQueue.main.async {
                self.title = self.entity?.shortTitle
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
    // MARK: - Init
    init(requestFactory: RequestFactory,
         currentId: Int) {
        self.requestFactory = requestFactory
        self.currentId = currentId
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
        detailEventView.collectionView.register(DetailNameCell.self,
                                                forCellWithReuseIdentifier: DetailNameCell.reuseId)
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
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()
        guard let entity = entity else {
            return
        }
        snapshot.appendSections([.photos, .description, .moreInfo, .place])
        snapshot.appendItems(entity.images, toSection: .photos)
        snapshot.appendItems([entity], toSection: .description)
        if showMoreInfo {
            snapshot.appendItems([entity.bodyText], toSection: .moreInfo)
        }
        if entity.place != nil {
            snapshot.appendItems([entity.place], toSection: .place)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    // MARK: - Request data methods
    private func requestData() {
        let eventsFactory = requestFactory.makeGetEventDetailFactory()
        eventsFactory.getEventDetail(eventID: currentId) { [ weak self] response in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch response {
                case .success(let event):
                    self.entity = event
                case .failure(let error):
                    self.showAlert(with: "Error!",
                                   and: error.localizedDescription)
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

