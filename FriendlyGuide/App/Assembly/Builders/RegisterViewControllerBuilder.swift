//
//  RegisterViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import UIKit

final class RegisterViewControllerBuilder {
    private lazy var passwordValidator: PasswordValidator = {
        BasicValidator()
    }()
    
    private lazy var loginValidator: LoginValidator = {
        BasicValidator()
    }()
    
    
    func build() -> RegisterViewController {
        let model = RegisterModel(passwordValidator: passwordValidator,
                                  loginValidator: loginValidator)
        
        let view = UIView()
        
        return RegisterViewController(model: model,
                                      customView: view)
    }
}
