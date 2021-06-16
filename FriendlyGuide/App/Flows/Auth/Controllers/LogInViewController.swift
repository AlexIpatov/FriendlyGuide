//
//  LogInViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit
import CoreLocation

enum LogInControllerError: LocalizedError {
    case noPassword, noLogin
    
    var errorDescription: String? {
        switch self {
        case .noLogin:
            return "Необходимо ввести логин"
        case .noPassword:
            return "Для начала необходимо задать пароль"
        }
    }
}

protocol LogInViewDelegate: AnyObject {
    func logInButtonWasTapped()
    func useBiometricButtonWasTaped()
    func gotoRegisterButtonWasTapped()
    
    func textFieldDidEndEditing(_ textField: UITextField, password: String)
    func textFieldDidEndEditing(_ textField: UITextField, login: String)
}

final class LogInViewController: UIViewController {
    private var window: UIWindow?
    private var model: LogInModelRepresentable
    private var loginRequestFactory: LogInRequestFactory
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
         loginRequestFactory: LogInRequestFactory,
         window: UIWindow?) {
        self.appMainViewControllerBuilder = appMainViewControllerBuilder
        self.registerViewControllerBuilder = registerViewControllerBuilder
        self.localAuthRequestFactory = localAuthRequestFactory
        self.keychainRequestFactory = keychainRequestFactory
        self.loginRequestFactory = loginRequestFactory
        self.customView = customView
        self.window = window
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useBiometricButtonWasTaped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?
            .setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationServicesStatus()
    }
    
    //MARK: - Location Services status checking
    private func checkLocationServicesStatus() {
        guard CLLocationManager.locationServicesEnabled() else {
            let alert = UIAlertController(
                title: "Службы геолокации отключены.",
                message: "Вы хотите перейти в настройки и включить службы геолокации?",
                preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Настройки",
                                               style: .default) { (alert) in
                if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION_SERVICES") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена",
                                             style: .cancel,
                                             handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}

extension LogInViewController: LogInViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, login: String) {
        update(textField: textField,
               with: model.tryToUpdate(login: login))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, password: String) {
        update(textField: textField,
               with: model.tryToUpdate(password: password))
    }
    
    private func update(textField: UITextField, with error: Error?) {
        error.map { error in
            errorTimeredView.show(in: view,
                                  y: AuthViewsParametrs.errorViewOffset(inView: view),
                                  with: error,
                                  duration: 1)
            textField.shake()
            textField.text = ""
        }
    }
    
    func gotoRegisterButtonWasTapped() {
        let registerVC = registerViewControllerBuilder.build(with: view.bounds)
        registerVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func logInButtonWasTapped() {
        if model.login.isEmpty {
            errorTimeredView.show(in: view,
                                  y: AuthViewsParametrs.errorViewOffset(inView: self.view),
                                  with: LogInControllerError.noLogin,
                                  duration: 1)
            return
        }
        
        if model.password.isEmpty {
            errorTimeredView.show(in: view,
                                  y: AuthViewsParametrs.errorViewOffset(inView: self.view),
                                  with: LogInControllerError.noPassword,
                                  duration: 1)
            return
        }
        
        login(with: model.login, and: model.password)
    }
    
    private func login(with login: String, and password: String) {
        loginRequestFactory.login(login: model.login, password: model.password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.errorTimeredView.show(in: self.view,
                                           y: AuthViewsParametrs.errorViewOffset(inView: self.view),
                                           with: error,
                                           duration: 1)
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
                self.errorTimeredView.show(in: self.view,
                                           y: AuthViewsParametrs.errorViewOffset(inView: self.view),
                                           with: error,
                                           duration: 1)
                return
            }
            
            localAuthRequestFactory.evaluate { [weak self] (success, error) in
                guard let self = self else {
                    return
                }
                
                guard success else {
                    guard let error = error else { return }
                    self.errorTimeredView.show(in: self.view,
                                               y: AuthViewsParametrs.errorViewOffset(inView: self.view),
                                               with: error,
                                               duration: 1)
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


