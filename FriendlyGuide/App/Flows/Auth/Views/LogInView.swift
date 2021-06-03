//
//  LogInView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

protocol LoginViewRepresentable {
    var delegate: LogInViewDelegate? { get set }
    
    func showRegisterButton()
}

final class LogInView: UIView {
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInButtonWasTapped(_:)),
                         for: .touchUpInside)
        setUpCommonParametrs(for: button)
        return button
    }()
    private lazy var gotoRegisterButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(gotoRegisterButtonWasTapped(_:)),
                         for: .touchUpInside)
        setUpCommonParametrs(for: button)
        return button
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
    private lazy var useBiometricButton: UIButton = {
        let button = UIButton()
        
        let imageConfiguration = UIImage
            .SymbolConfiguration(font: .systemFont(ofSize: 50))
        
        let image = UIImage(systemName: "faceid",
                            withConfiguration: imageConfiguration)
        
        button.setImage(image, for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(useBiometricButtonWasTaped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    weak var delegate: LogInViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addGestureRecognizers()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func logInButtonWasTapped(_ sender: UIButton) {
        delegate?.logInButtonWasTapped()
    }
    
    @objc private func gotoRegisterButtonWasTapped(_ sender: UIButton) {
        delegate?.gotoRegisterButtonWasTapped()
    }
    
    @objc private func useBiometricButtonWasTaped(_ sender: UIButton) {
        delegate?.useBiometricButtonWasTaped()
    }
        
    private func setUpCommonParametrs(for textField: UITextField) {
        textField.delegate = self
        textField.leftView = AuthViewsParametrs.placeholderInsetsView
        textField.leftViewMode = .always
    }
    
    private func setUpCommonParametrs(for button: UIButton) {
        button.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        button.layer.borderWidth = AuthViewsParametrs.borderWidth
        button.layer.borderColor = AuthViewsParametrs.borderColor
        
        button.backgroundColor = AuthViewsParametrs.buttonBackgroundColor
        button.setTitleColor(.black, for: .normal)
    }
    
    private func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
    }
    
    private func configureUI() {
        let textFieldsStackView = UIStackView(arrangedSubviews: [loginTextField,
                                                                 AuthViewsParametrs.separatorView,
                                                                 passwordTextField ],
                                              axis: .vertical,
                                              spacing: AuthViewsParametrs.textFieldsSpacing)
        textFieldsStackView.layer.borderWidth = AuthViewsParametrs.borderWidth
        textFieldsStackView.layer.borderColor = AuthViewsParametrs.borderColor
        textFieldsStackView.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        
        
        let buttonsStackView = UIStackView(arrangedSubviews: [
                                            logInButton,
                                            gotoRegisterButton,
                                            useBiometricButton ],
                                           axis: .vertical,
                                           spacing: AuthViewsParametrs.buttonsSpacing)
        
        
        let mainStackView = UIStackView(arrangedSubviews: [
                                            textFieldsStackView,
                                            buttonsStackView ],
                                        axis: .vertical,
                                        spacing: AuthViewsParametrs.textFieldsButtonsSpacing)
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: frame.width * 0.7),
        ])
    }
}

extension LogInView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard !(textField.text ?? "").isEmpty else {
            return
        }
        
        switch textField {
        case loginTextField:
            delegate?.textFieldDidEndEditing(textField, login: textField.text ?? "")
        case passwordTextField:
            delegate?.textFieldDidEndEditing(textField, password: textField.text ?? "")
        default:
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension LogInView: LoginViewRepresentable {
    func showRegisterButton() {
        UIView.transition(with: gotoRegisterButton,
                          duration: 0.8,
                          options: .transitionCrossDissolve) { [weak self] in
            self?.gotoRegisterButton.isHidden = false
        }
    }
}
