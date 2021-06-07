//
//  RegisterViewController.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 31.05.2021.
//

import UIKit

enum RegisterControllerError: LocalizedError {
    case noName, noPassword, noConfirmPassword, noLogin
    
    var errorDescription: String? {
        switch self {
        case .noName:
            return "Для начала введите имя"
        case .noLogin:
            return "Необходимо ввести логин"
        case .noPassword:
            return "Для начала необходимо задать пароль"
        case .noConfirmPassword:
            return "Подтвердите пароль"
        }
    }
}

protocol RegisterViewDelegate: AnyObject {
    func registerButtonWasTapped()
    
    func textFieldDidEndEditing(_ textField: UITextField, name: String)
    func textFieldDidEndEditing(_ textField: UITextField, login: String)
    func textFieldDidEndEditing(_ textField: UITextField, password: String)
    func textFieldDidEndEditing(_ textField: UITextField, confirmPassword: String)
}

protocol RegisterModelDelegate: AnyObject {
    func prepareToShowSignInButton()
    func prepareToShowConfirmPasswordTextField()
}

final class RegisterViewController: UIViewController {
    
    private let errorTimeredView = TimeredLableView(style: .error)
    
    private var customView: RegisterViewRepresentable
    private var model: RegisterModelRepresentable
    
    private var chatManager: ChatManager
    
    private var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    init(model: RegisterModelRepresentable, customView: (RegisterViewRepresentable & UIView),
         chatManager: ChatManager) {
        self.chatManager = chatManager
        self.customView = customView
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?
            .setNavigationBarHidden(false, animated: true)
    }
}

extension RegisterViewController: RegisterViewDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, name: String) {
        update(textField: textField,
               with: model.tryToUpdate(name: name))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, login: String) {
        update(textField: textField,
               with: model.tryToUpdate(login: login))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, password: String) {
        update(textField: textField,
               with: model.tryToUpdate(password: password))
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, confirmPassword: String) {
        update(textField: textField,
               with: model.tryToUpdate(confirmPassword: confirmPassword))
    }
    
    private func update(textField: UITextField, with error: Error?) {
        error.map { error in
            errorTimeredView.show(in: view,
                                  y: 100,
                                  with: error,
                                  duration: 1)
            textField.shake()
            textField.text = ""
        }
    }
    
    func registerButtonWasTapped() {
        if model.name.isEmpty {
            self.errorTimeredView.show(in: self.view,
                                       y: 100,
                                       with: RegisterControllerError.noName,
                                       duration: 1)
            return
        }
        
        if model.login.isEmpty {
            self.errorTimeredView.show(in: self.view,
                                       y: 100,
                                       with: RegisterControllerError.noLogin,
                                       duration: 1)
            return
        }
        
        if model.password.isEmpty {
            self.errorTimeredView.show(in: self.view,
                                       y: 100,
                                       with: RegisterControllerError.noPassword,
                                       duration: 1)
            return
        }
        
        if model.confirmPassword.isEmpty {
            self.errorTimeredView.show(in: self.view,
                                       y: 100,
                                       with: RegisterControllerError.noConfirmPassword,
                                       duration: 1)
            return
        }
        
        
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
                self.errorTimeredView.show(in: self.view,
                                           y: 100,
                                           with: error,
                                           duration: 1)
            }
        }
    }
}

extension RegisterViewController: RegisterModelDelegate {
    func prepareToShowConfirmPasswordTextField() {
        customView.showConfirmPasswordTextField()
    }
    
    func prepareToShowSignInButton() {
        customView.showSignInButton()
    }
}
