//
//  AuthViewControllerImpl.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

class AuthViewControllerImpl: UIViewController, AuthViewController {
    
    private var model: AuthModel
    private var customView: AuthView
    
    private var manager: ChatManager {
        QBChatManager.instance
    }
    
    required init(model: AuthModel, customView: AuthView) {
        self.customView = customView
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
        
        self.customView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var okAction: UIAlertAction {
        UIAlertAction(title: "OK", style: .default, handler: nil)
    }
    private var goToRegisterAction: UIAlertAction {
        UIAlertAction(title: "Register", style: .default) { [weak self] _ in
            return
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

extension AuthViewControllerImpl: AuthViewConnectable {
    func changeLogin(on newLogin: String) -> Bool {
        checkUpdateResult(model.update(login: newLogin))
    }
    
    func changePassword(on newPassword: String) -> Bool {
        checkUpdateResult(model.update(password: newPassword)) 
    }
    
    private func checkUpdateResult(_ result: Result<Bool, Error>) -> Bool {
        switch result {
        case .failure(let error):
            showAlert(title: "Update Error",
                      error: error,
                      style: .alert,
                      actions: [okAction])
            return false
        case .success:
            return true
        }
    }
    
    func logIn() {
        let (login, password) = model.getLogInData()
        
        manager.login(login: login, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                self.showAlert(title: "Log In Error",
                               error: error,
                               style: .alert,
                               actions: [self.okAction])
            case .success:
                return
            }
        }
    }
}
