//
//  AuthControllersFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 03.06.2021.
//

import UIKit

final class AuthControllersFactory {
    private var registerViewControllerBuilder: RegisterViewControllerBuilder {
        self
    }
    
    private var chatManager: ChatManager {
        QBChatManager.instance
    }
    
    private lazy var appMainViewControllerBuilder: AppMainViewControllerBuilder = {
        AppMainViewControllerBuilder()
    }()
    
    private lazy var passwordValidator: PasswordValidator = {
        BasicValidator()
    }()
    
    private lazy var loginValidator: LoginValidator = {
        BasicValidator()
    }()
    
    private lazy var localAuthRequestFactory: LocalAuthRequestFactory = {
        BiometricIDAuth()
    }()
    
    private lazy var keychainRequestFactory: KeychainRequestFactory = {
        LocksmithKeychain()
    }()
    
    private let window: UIWindow?
    init(window: UIWindow?) {
        self.window = window
    }
}

extension AuthControllersFactory: LogInViewControllerBuilder {
    func build(with frame: CGRect) -> (LogInViewDelegate & UIViewController) {
        let model = LogInModel(passwordValidator: passwordValidator,
                               loginValidator: loginValidator)
        
        let view = LogInView(frame: frame)
        
        
        let loginViewController = LogInViewController(model: model,
                                                      customView: view,
                                                      registerViewControllerBuilder: registerViewControllerBuilder,
                                                      appMainViewControllerBuilder: appMainViewControllerBuilder,
                                                      localAuthRequestFactory: localAuthRequestFactory,
                                                      keychainRequestFactory: keychainRequestFactory,
                                                      chatManager: chatManager,
                                                      window: window)
        
        view.delegate = loginViewController
        return loginViewController
    }
}
extension AuthControllersFactory: RegisterViewControllerBuilder {
    func build(with frame: CGRect) -> (RegisterViewDelegate & UIViewController) {
        let model = RegisterModel(passwordValidator: passwordValidator,
                                  loginValidator: loginValidator)
        
        
        let view = RegisterView(frame: frame)
        
        let controller = RegisterViewController(model: model,
                                                customView: view,
                                                chatManager:chatManager)
        model.delegate = controller
        view.delegate = controller
        return controller
    }
}
