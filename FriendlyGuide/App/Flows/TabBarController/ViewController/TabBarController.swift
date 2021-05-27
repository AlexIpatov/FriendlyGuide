//
//  TabBarController.swift
//  FriendlyGuide
//
//  Created by Sergey Razgulyaev on 24.05.2021.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Init
    init() {
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
        let travelScreenViewController = TravelScreenViewController()
        travelScreenViewController.tabBarItem = UITabBarItem(title: "Travel",
                                                             image: UIImage(systemName: "figure.walk.diamond"),
                                                             selectedImage: UIImage(systemName: "figure.walk.diamond.fill"))
        let travelNavigationController = UINavigationController(rootViewController: travelScreenViewController)
        configureNavigationController(navigationController: travelNavigationController,
                                      tintColor: .systemBlue,
                                      barTintColor: .systemGray6,
                                      prefersLargeTitles: false)
        viewControllers.append(travelNavigationController)
        
        //2. MapScreen
        let mapScreenViewController = MapScreenViewController()
        mapScreenViewController.tabBarItem = UITabBarItem(title: "Map",
                                                          image: UIImage(systemName: "map"),
                                                          selectedImage: UIImage(systemName: "map.fill"))
        let mapScreenNavigationController = UINavigationController(rootViewController: mapScreenViewController)
        configureNavigationController(navigationController: mapScreenNavigationController,
                                              tintColor: .systemBlue,
                                              barTintColor: .systemGray6,
                                              prefersLargeTitles: false)
        viewControllers.append(mapScreenNavigationController)
        
        //3. ChatScreen
        let chatScreenViewController = ChatListViewController()
        chatScreenViewController.tabBarItem = UITabBarItem(title: "Chat",
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
        profileScreenViewController.tabBarItem = UITabBarItem(title: "Profile",
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
