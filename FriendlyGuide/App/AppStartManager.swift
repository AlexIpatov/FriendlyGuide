//
//  AppStartManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 01.06.2021.
//

import UIKit

final class AppStartManager {
    
    private var window: UIWindow?
    
    private lazy var rootViewController: (LogInViewDelegate & UIViewController) = {
        AuthControllersFactory(window: window)
            .build(with: window?.bounds ?? .zero)
    }()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let navVC = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
//    let tabBarController = TabBarController(requestFactory: requestFactory,
//                                            userSettings: userSettings)
//    window?.rootViewController = tabBarController
//    window?.makeKeyAndVisible()
}
