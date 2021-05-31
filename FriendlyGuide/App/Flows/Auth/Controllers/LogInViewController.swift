//
//  LogInViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit

protocol LogInViewDelegate {
    func logInButtonWasTapped()
    func gotoRegisterButtonWasTapped()
    
    func update(login: String) -> Bool
    func update(password: String) -> Bool
}

final class LogInViewController: UIViewController {
    private var model: LogInModelRepresentable
    private var manager: ChatManager {
        QBChatManager.instance
    }
    
    private var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    private let registerViewControllerBuilder: RegisterViewControllerBuilder
    private let appMainViewControllerBuilder: AppMainViewControllerBuilder
    
    init(model: LogInModelRepresentable, customView: UIView,
         registerViewControllerBuilder: RegisterViewControllerBuilder,
         appMainViewControllerBuilder: AppMainViewControllerBuilder) {
        self.appMainViewControllerBuilder = appMainViewControllerBuilder
        self.registerViewControllerBuilder = registerViewControllerBuilder
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private var okAction: UIAlertAction {
        UIAlertAction(title: "OK",
                      style: .default,
                      handler: nil)
    }
    
    private var gotoRegisterAction: UIAlertAction {
        UIAlertAction(title: "Register",
                      style: .default) { [weak self] _ in
            self?.gotoRegisterButtonWasTapped()
        }
    }
    
    private func showAlert(title: String, error: Error, style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title,
                                                message: error.localizedDescription,
                                                preferredStyle: style)
        
        actions.forEach { alertController.addAction($0) }
        present(alertController, animated: true, completion: nil)
    }
}

extension LogInViewController: LogInViewDelegate {
    func update(login: String) -> Bool {
        check(model.tryToUpdate(login: login))
    }
    
    func update(password: String) -> Bool {
        check(model.tryToUpdate(password: password))
    }
    
    private func check(_ result: Result<Bool, Error>) -> Bool {
        switch result {
        case .failure(let error):
            self.showAlert(title: "Update Error",
                           error: error,
                           style: .alert,
                           actions: [self.okAction])
            return false
        case .success(let updateResult):
            return updateResult
        }
    }
    
    func gotoRegisterButtonWasTapped() {
        let registerVC = registerViewControllerBuilder.build()
        navigationController?.present(registerVC, animated: true)
    }
    
    func logInButtonWasTapped() {
        manager.login(login: model.login, password: model.password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.showAlert(title: "Log In Error",
                               error: error,
                               style: .alert,
                               actions: [self.okAction, self.gotoRegisterAction])
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
}
