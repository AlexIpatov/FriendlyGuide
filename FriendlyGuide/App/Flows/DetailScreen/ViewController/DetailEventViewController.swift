//
//  DetailEventViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import UIKit

class DetailEventViewController: UIViewController {
    // MARK: - UI components
    private lazy var travelScreenView: TravelScreenView = {
        return TravelScreenView()
    }()
    // MARK: - Properties
    var requestFactory: RequestFactory
    private var currentId: Int
    var entity: EventDetail? {
        didSet {
            reloadData()
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
        super.viewDidLoad()
        configureViewController()
        setupCollectionView()
        createDataSource()
        reloadData()
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
    var dataSource: UICollectionViewDiffableDataSource<DetailSection, AnyHashable>?
    private func setupCollectionView() {

        travelScreenView.collectionView.register(DetailNameCell.self,
                                                 forCellWithReuseIdentifier: DetailNameCell.reuseId)
        travelScreenView.collectionView.register(DetailImageCell.self,
                                                 forCellWithReuseIdentifier: DetailImageCell.reuseId)
        travelScreenView.collectionView.register(DetailDescriptionCell.self,
                                                 forCellWithReuseIdentifier: DetailDescriptionCell.reuseId)
        travelScreenView.collectionView.register(DetailMoreInfoCell.self,
                                                 forCellWithReuseIdentifier: DetailMoreInfoCell.reuseId)
        travelScreenView.collectionView.delegate = self
    }
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection, AnyHashable>()
        guard let entity = entity else {
            return
        }
        snapshot.appendSections([.title, .photos, .description, .moreInfo])
        snapshot.appendItems([entity.title], toSection: .title)
        snapshot.appendItems(entity.images, toSection: .photos)
        snapshot.appendItems([entity.bodyText], toSection: .description)
        snapshot.appendItems([entity], toSection: .moreInfo)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    // MARK: - Request data methods
    private func requestData() {
        let eventsFactory = requestFactory.makeGetEventDetailFactory()
        eventsFactory.getEventDetail(eventID: currentId) { [ weak self] response in
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
// MARK: - Data Source
extension DetailEventViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<DetailSection,
                                                        AnyHashable>(collectionView: travelScreenView.collectionView,
                                                                     cellProvider: {(collectionView,
                                                                                     indexPath, item) -> UICollectionViewCell? in
                                                                        guard let section = DetailSection(rawValue: indexPath.section) else {
                                                                            fatalError("Unknown section kind")
                                                                        }
                                                                        switch section {
                                                                        case .title:
                                                                            return self.configure(collectionView: collectionView,
                                                                                                  cellType: DetailNameCell.self,
                                                                                                  with: item,
                                                                                                  for: indexPath)
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
extension DetailEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
