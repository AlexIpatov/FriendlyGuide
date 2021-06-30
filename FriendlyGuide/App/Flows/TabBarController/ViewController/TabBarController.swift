//
//  TabBarController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit
import CoreLocation

class TabBarController: UITabBarController {
    // MARK: - Properties
    private var dataProvider: DataProvider
    private var userSettings: UserSettings
    private var requestFactory: RequestFactory

    // MARK: - Init
    init(requestFactory: RequestFactory,
         userSettings: UserSettings,
         dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        self.requestFactory = requestFactory
        self.userSettings = userSettings
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = createViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
    }
    
    //MARK: - Configuration Methods
    func configureTabBarController() {
        self.tabBar.barTintColor = .systemGray6
        self.tabBar.tintColor = .systemBlue
    }
    
    func createViewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        //1. TravelScreen
        let travelScreenViewController = TravelScreenViewController(requestFactory: requestFactory,
                                                                    userSettings: userSettings, dataProvider: dataProvider)
        travelScreenViewController.tabBarItem = UITabBarItem(title: "Путешествие",
                                                             image: UIImage(systemName: "figure.walk.diamond"),
                                                             selectedImage: UIImage(systemName: "figure.walk.diamond.fill"))
        let travelNavigationController = UINavigationController(rootViewController: travelScreenViewController)
        configureNavigationController(navigationController: travelNavigationController,
                                      tintColor: .systemBlue,
                                      barTintColor: .systemGray6,
                                      prefersLargeTitles: false)
        viewControllers.append(travelNavigationController)
        
        //2. MapScreen
        let mapScreenViewController = MapScreenViewController(
            dataProvider: dataProvider)
        mapScreenViewController.tabBarItem = UITabBarItem(title: "Карта",
                                                          image: UIImage(systemName: "map"),
                                                          selectedImage: UIImage(systemName: "map.fill"))
        let mapScreenNavigationController = UINavigationController(rootViewController: mapScreenViewController)
        configureNavigationController(navigationController: mapScreenNavigationController,
                                      tintColor: .systemBlue,
                                      barTintColor: .systemGray6,
                                      prefersLargeTitles: false)
        viewControllers.append(mapScreenNavigationController)
        
        //3. ChatScreen
        let chatBuilder = ChatControllersFactory(requestFactory: requestFactory)
        let chatScreenViewController = chatBuilder.build(with: self.view.bounds)
        chatScreenViewController.tabBarItem = UITabBarItem(title: "Чат",
                                                           image: UIImage(systemName: "bubble.left.and.bubble.right"),
                                                           selectedImage: UIImage(systemName: "bubble.left.and.bubble.right.fill"))
        let chatNavigationController = UINavigationController(rootViewController: chatScreenViewController)
        configureNavigationController(navigationController: chatNavigationController,
                                      tintColor: .systemBlue,
                                      barTintColor: .systemGray6,
                                      prefersLargeTitles: false)
        viewControllers.append(chatNavigationController)
        
        //4. ProfileScreen
        let profileScreenViewController = ProfileScreenViewController()
        profileScreenViewController.tabBarItem = UITabBarItem(title: "Профиль",
                                                              image: UIImage(systemName: "person.circle"),
                                                              selectedImage: UIImage(systemName: "person.circle.fill"))
        let profileNavigationController = UINavigationController(rootViewController: profileScreenViewController)
        configureNavigationController(navigationController: profileNavigationController,
                                      tintColor: .systemBlue,
                                      barTintColor: .systemGray6,
                                      prefersLargeTitles: false)
        viewControllers.append(profileNavigationController)
        
        return viewControllers
    }
    
    func configureNavigationController(navigationController: UINavigationController,
                                       tintColor: UIColor,
                                       barTintColor: UIColor,
                                       prefersLargeTitles: Bool) {
        navigationController.navigationBar.tintColor = tintColor
        navigationController.navigationBar.barTintColor = barTintColor
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
    }
}
