//
//  MoreContentViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 17.06.2021.
//
import UIKit

class MoreContentViewController: UIViewController {
    // MARK: - UI components
    private lazy var moreContentView: MoreContentView = {
        return MoreContentView()
    }()
    // MARK: - Properties
    var requestFactory: RequestFactory
    var results = [Event]()
    var currentSectionType: TravelSection
    // MARK: - Init
    init(requestFactory: RequestFactory,
         currentId: Int,
         currentSectionType: TravelSection) {
        self.requestFactory = requestFactory
        self.currentSectionType = currentSectionType
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewController Lifecycle
    override func loadView() {
        view = moreContentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        setupCollectionView()
        requestData()
    }
    
    // MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    // MARK: - CollectionView set up
    private func setupCollectionView() {
        moreContentView.collectionView.register(EventCell.self,
                                                forCellWithReuseIdentifier: DetailDescriptionCell.reuseId)

        moreContentView.collectionView.delegate = self
        moreContentView.collectionView.dataSource = self
        moreContentView.collectionView.prefetchDataSource = self
    }
    // MARK: - Request data methods
    private func requestData() {
        print("Some request with paging")
    }
}
// MARK: - Data Source
extension MoreContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        results.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.configure(collectionView: collectionView,
                       cellType: EventCell.self,
                       with: results,
                       for: indexPath)
    }
}
// MARK: - UICollectionViewDelegate
extension MoreContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        //УБрать в роутер
        let detailVC = DetailEventViewController(requestFactory: requestFactory,
                                                 currentId: results[indexPath.row].id,
                                                 currentSectionType: currentSectionType)
        navigationController?.pushViewController(detailVC,
                                                 animated: true)
    }
}
// MARK: - UICollectionViewDataSourcePrefetching
extension MoreContentViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: isloadingCell(for:)) else {
            return
        }
        print("RequestMore")
    }
       func isloadingCell(for indexPath: IndexPath) -> Bool {
            var resultsCount: Int
            resultsCount = results.count
            return indexPath.row == resultsCount - 3
        }
}
// MARK: - Actions
extension MoreContentViewController {
}
