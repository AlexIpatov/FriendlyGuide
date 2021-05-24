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
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func loadView() {
        view = travelScreenView
    }
    
    //MARK: - Configuration Methods
    func configureViewController() {
        view.backgroundColor = .white
        self.title = "Travel"
    }
}
