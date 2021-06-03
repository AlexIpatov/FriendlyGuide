//
//  RegisterView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 03.06.2021.
//

import UIKit

protocol RegisterViewRepresentable: AnyObject {
    var delegate: RegisterViewDelegate? { get set }
    
    func showConfirmPasswordTextField()
    func showSignInButton()
}

final class RegisterView: UIView {
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "name"
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "login"
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "confirm password"
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
                                                nameTextField,
                                                AuthViewsParametrs.separatorView,
                                                
                                                loginTextField,
                                                AuthViewsParametrs.separatorView,
                                                
                                                passwordTextField ],
                                              axis: .vertical,
                                              spacing: AuthViewsParametrs.textFieldsSpacing)
        
        stackView.layer.borderWidth = AuthViewsParametrs.borderWidth
        stackView.layer.borderColor = AuthViewsParametrs.borderColor
        stackView.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        button.layer.borderWidth = AuthViewsParametrs.borderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = UIColor.white
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(registerButtonWasTapped(_:)),
                         for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    
    weak var delegate: RegisterViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addGestureRecognizers()
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func registerButtonWasTapped(_ sender: UIButton) {
        delegate?.registerButtonWasTapped()
    }
    
    private func configureUI() {
        let mainStackView = UIStackView(arrangedSubviews: [
                                            textFieldsStackView,
                                            registerButton ],
                                        axis: .vertical,
                                        spacing: AuthViewsParametrs.textFieldsButtonsSpacing)
        
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        
        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            loginTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            
            
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: frame.width * 0.7),
        ])
    }
    
    private func setUpCommonParametrs(for textField: UITextField) {
        textField.delegate = self
        textField.leftView = AuthViewsParametrs.placeholderInsetsView
        textField.leftViewMode = .always
    }
    
    private func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
    }
}

extension RegisterView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard !(textField.text ?? "").isEmpty else {
            return
        }
        
        switch textField {
        case loginTextField:
            delegate?.textFieldDidEndEditing(textField, login: textField.text ?? "")
        case passwordTextField:
            delegate?.textFieldDidEndEditing(textField, password: textField.text ?? "")
        case nameTextField:
            delegate?.textFieldDidEndEditing(textField, name: textField.text ?? "")
        case confirmPasswordTextField:
            delegate?.textFieldDidEndEditing(textField, confirmPassword: textField.text ?? "")
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegisterView: RegisterViewRepresentable {
    func showSignInButton() {
        UIView.transition(with: registerButton,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { [weak self] in
            self?.registerButton.isHidden = false
        }
    }
    
    func showConfirmPasswordTextField() {
        UIView.transition(with: textFieldsStackView,
                          duration: 0.5,
                          options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.textFieldsStackView.addArrangedSubview(AuthViewsParametrs.separatorView)
            self.textFieldsStackView.addArrangedSubview(self.confirmPasswordTextField)
        }
    }
}
