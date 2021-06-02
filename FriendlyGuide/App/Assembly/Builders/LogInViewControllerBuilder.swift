//
//  LogInViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit

final class LogInViewControllerBuilder {
    private lazy var registerViewControllerBuilder: RegisterViewControllerBuilder = {
        RegisterViewControllerBuilder()
    }()
    
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
                                                      chatManager: QBChatManager.instance)
        
        view.delegate = loginViewController
        return loginViewController
    }
}
