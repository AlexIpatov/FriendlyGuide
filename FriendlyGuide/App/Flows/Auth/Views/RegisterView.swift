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
        textField.leftView = AuthViewsParametrs
            .placeholderInsetsImageView(with: "person.fill")
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "login"
        textField.leftView = AuthViewsParametrs
            .placeholderInsetsImageView(with: "person")
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.leftView = AuthViewsParametrs
            .placeholderInsetsImageView(with: "key")
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "confirm password"
        textField.leftView = AuthViewsParametrs
            .placeholderInsetsImageView(with: "key.fill")
        
        setUpCommonParametrs(for: textField)
        return textField
    }()
    
    
    private lazy var textFieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
                                        nameTextField,
                                        loginTextField,
                                        passwordTextField ],
                                    axis: .vertical,
                                    spacing: AuthViewsParametrs.textFieldsSpacing)
        stackView.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        stackView.backgroundColor = AuthViewsParametrs.textFieldBackgroundColor
        
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        shadowView.layer.shadowOpacity = AuthViewsParametrs.shadowOpacity
        shadowView.layer.shadowRadius = AuthViewsParametrs.shadowRadius
        shadowView.layer.shadowOffset = AuthViewsParametrs.shadowOffset
        shadowView.layer.shadowColor = AuthViewsParametrs.shadowColor
        shadowView.layer.shadowPath = CGPath(rect: shadowPathRect,
                                             transform: nil)
        shadowView.addSubview(textFieldsStackView)
        return shadowView
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        button.layer.shadowColor = AuthViewsParametrs.shadowColor
        button.layer.shadowRadius = AuthViewsParametrs.shadowRadius
        button.layer.shadowOpacity = AuthViewsParametrs.shadowOpacity
        button.layer.shadowOffset = .zero
        
        button.backgroundColor = AuthViewsParametrs.buttonBackgroundColor
        button.setTitleColor(AuthViewsParametrs.buttonTitleColor, for: .normal)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(registerButtonWasTapped(_:)),
                         for: .touchUpInside)
        
        button.isHidden = true
        return button
    }()
    
    private var shadowPathRect: CGRect {
        CGRect(x: 0, y: 0,
               width: frame.width * 0.7,
               height: textFieldsStackView.arrangedSubviews.reduce(0) { height, view in
                if view is UITextField {
                    return height + AuthViewsParametrs.textFieldHeight
                } else { return height }
               })
    }
    
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
                                            shadowView,
                                            registerButton ],
                                        axis: .vertical,
                                        spacing: AuthViewsParametrs.textFieldsButtonsSpacing)
        
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        
        NSLayoutConstraint.activate([
            textFieldsStackView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            textFieldsStackView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            textFieldsStackView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            textFieldsStackView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            
            nameTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            loginTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            
            registerButton.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.buttonHeight),
            
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: frame.width * 0.7),
        ])
    }
    
    private func setUpCommonParametrs(for textField: UITextField) {
        textField.delegate = self
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
            print("no")
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
            self.textFieldsStackView.addArrangedSubview(self.confirmPasswordTextField)
            self.shadowView.layer.shadowPath = CGPath(rect: self.shadowPathRect,
                                                      transform: nil)
        }
    }
}
