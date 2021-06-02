//
//  LogInViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit

protocol LogInViewDelegate: AnyObject {
    func logInButtonWasTapped()
    func useBiometricButtonWasTaped()
    func gotoRegisterButtonWasTapped()
    
    func textFieldDidEndEditing(_ textField: UITextField, password: String)
    func textFieldDidEndEditing(_ textField: UITextField, login: String)
}

final class LogInViewController: UIViewController {
    private var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    private var model: LogInModelRepresentable
    private var chatManager: ChatManager
    private var customView: LoginViewRepresentable
    private let registerViewControllerBuilder: RegisterViewControllerBuilder
    private let appMainViewControllerBuilder: AppMainViewControllerBuilder
    private let localAuthRequestFactory: LocalAuthRequestFactory
    private let keychainRequestFactory: KeychainRequestFactory
    
    private let errorTimeredView = TimeredLableView(style: .error)
    
    init(model: LogInModelRepresentable, customView: (UIView & LoginViewRepresentable),
         registerViewControllerBuilder: RegisterViewControllerBuilder,
         appMainViewControllerBuilder: AppMainViewControllerBuilder,
         localAuthRequestFactory: LocalAuthRequestFactory,
         keychainRequestFactory: KeychainRequestFactory,
         chatManager: ChatManager) {
        self.appMainViewControllerBuilder = appMainViewControllerBuilder
        self.registerViewControllerBuilder = registerViewControllerBuilder
        self.localAuthRequestFactory = localAuthRequestFactory
        self.keychainRequestFactory = keychainRequestFactory
        self.chatManager = chatManager
        self.customView = customView
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var okAction: UIAlertAction {
        UIAlertAction(title: "OK",
                      style: .default)
    }
}

extension LogInViewController: LogInViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, login: String) {
        if let error = model.tryToUpdate(login: login) {
            errorTimeredView.show(in: view,
                                  y: 100,
                                  with: error,
                                  duration: 1)
            customView.shake(textField)
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, password: String) {
        if let error = model.tryToUpdate(password: password) {
            errorTimeredView.show(in: view,
                                  y: 100,
                                  with: error,
                                  duration: 1)
            customView.shake(textField)
            textField.text = ""
        }
    }
    
    func gotoRegisterButtonWasTapped() {
        let registerVC = registerViewControllerBuilder.build()
        navigationController?.present(registerVC, animated: true)
    }
    
    func logInButtonWasTapped() {
        login(with: model.login, and: model.password)
    }
    
    private func login(with login: String, and password: String) {
        chatManager.login(login: model.login, password: model.password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.showErrorAlert(title: "Log In Error",
                                    error: error, actions: [self.okAction])
                self.customView.showRegisterButton()
            case .success:
                self.presentAppMainViewController()
            }
        }
    }

    private func presentAppMainViewController() {
        let app = appMainViewControllerBuilder.build()
        window?.rootViewController = app
        window?.makeKeyAndVisible()
    }
    
    func useBiometricButtonWasTaped() {
        localAuthRequestFactory.canEvaluate { [weak self] (canEvaluate, _, error) in
            guard let self = self else {
                return
            }
            
            guard canEvaluate else {
                guard let error = error else { return }
                self.showErrorAlert(title: "",
                                     error: error,
                                     actions: [self.okAction])
                return
            }
            
            localAuthRequestFactory.evaluate { [weak self] (success, error) in
                guard let self = self else {
                    return
                }
                
                guard success else {
                    guard let error = error else { return }
                    self.showErrorAlert(title: "",
                                         error: error,
                                         actions: [self.okAction])
                    return
                }
                
                if let login: String = self.keychainRequestFactory.get(request: LoginKeychainRequest()),
                   let password: String = self.keychainRequestFactory.get(request: PasswordKeychainRequest()) {
                    self.login(with: login, and: password)
                }
                
                self.presentAppMainViewController()
            }
        }
    }
}


