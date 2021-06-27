//
//  AuthControllersFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 03.06.2021.
//

import UIKit

final class AuthControllersFactory {
    private var registerViewControllerBuilder: RegisterViewControllerBuilder { self }
    private lazy var appMainViewControllerBuilder: AppMainViewControllerBuilder = {
        AppMainViewControllerBuilder(requestFactory: requestFactory)
    }()
    
    private lazy var loginPasswordValidator: (LoginValidator&
                                              PasswordValidator) = { BasicValidator() }()
    
    private let requestFactory: RequestFactory
    private let window: UIWindow?
    
    init(window: UIWindow?, requestFactory: RequestFactory) {
        self.requestFactory = requestFactory
        self.window = window
    }
}

extension AuthControllersFactory: LogInViewControllerBuilder {
    func build(with frame: CGRect) -> (LogInViewDelegate & UIViewController) {
        let model = LogInModel(passwordValidator: loginPasswordValidator,
                               loginValidator: loginPasswordValidator)
        
        let view = LogInView(frame: frame)
        
        
        
        let loginViewController = LogInViewController(model: model,
                                                      customView: view,
                                                      registerViewControllerBuilder: registerViewControllerBuilder,
                                                      appMainViewControllerBuilder: appMainViewControllerBuilder,
                                                      localAuthRequestFactory: requestFactory.makeLocalAuthRequestFactory(),
                                                      keychainRequestFactory: requestFactory.makeKeychainRequestFactory(),
                                                      loginRequestFactory: requestFactory.makeLogInRequestFactory(),
                                                      window: window)
        view.delegate = loginViewController
        return loginViewController
    }
}
extension AuthControllersFactory: RegisterViewControllerBuilder {
    func build(with frame: CGRect) -> (RegisterViewDelegate & UIViewController) {
        let model = RegisterModel(passwordValidator: loginPasswordValidator,
                                  loginValidator: loginPasswordValidator)
        
        let view = RegisterView(frame: frame)
        
        
        
        let controller = RegisterViewController(model: model,
                                                customView: view,
                                                signUpRequestFactory: requestFactory.makeSignUpRequestFactory())
        model.delegate = controller
        view.delegate = controller
        return controller
    }
}
