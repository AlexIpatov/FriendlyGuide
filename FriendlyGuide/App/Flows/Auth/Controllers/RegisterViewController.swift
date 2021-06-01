//
//  RegisterViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit

    
protocol RegisterViewDelegate {
    func registerButtonWasTapped()
    
    func update(name: String) -> Bool
    func update(login: String) -> Bool
    func update(password: String) -> Bool
    func update(confirmPassword: String) -> Bool
}

final class RegisterViewController: UIViewController {
    private var model: RegisterModel
    private var chatManager: ChatManager {
        QBChatManager.instance
    }
    
    private var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    private var okAction: UIAlertAction {
        UIAlertAction(title: "OK",
                      style: .default,
                      handler: nil)
    }


    init(model: RegisterModel, customView: UIView) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RegisterViewController: RegisterViewDelegate {
    func update(login: String) -> Bool {
        check(model.tryToUpdate(login: login))
    }
    
    func update(password: String) -> Bool {
        check(model.tryToUpdate(password: password))
    }
    
    func update(confirmPassword: String) -> Bool {
        check(model.tryToUpdate(confirmPassword: confirmPassword))
    }
    
    func update(name: String) -> Bool {
        check(model.tryToUpdate(name: name))
    }
    
    private func check(_ result: Result<Bool, Error>) -> Bool {
        switch result {
        case .failure(let error):
            showErrorAlert(title: "Update Error",
                           error: error,
                           actions: [okAction])
            return false
        case .success(let updateResult):
            return updateResult
        }
    }
    
    func registerButtonWasTapped() {
        chatManager.signUp(fullName: model.name,
                           login: model.login,
                           password: model.password) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showErrorAlert(title: "Register Error",
                                    error: error,
                                    actions: [self.okAction])
            }
        }
    }
}
