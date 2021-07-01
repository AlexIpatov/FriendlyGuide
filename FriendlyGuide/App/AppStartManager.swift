//
//  AppStartManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 01.06.2021.
//

import UIKit

final class AppStartManager {
    
    private var window: UIWindow?
    private let requestFactory = RequestFactory()
    
    private lazy var rootViewController: (LogInViewDelegate & UIViewController) = {
        AuthControllersFactory(window: window, requestFactory: requestFactory)
            .build(with: window?.bounds ?? .zero)
    }()
    
    init(window: UIWindow?) {
        self.window = window
        windowSettings()
    }

    func windowSettings() {
        window?.overrideUserInterfaceStyle = .light
    }
    
    func start() {
        let navVC = UINavigationController(rootViewController: rootViewController)
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }

}
