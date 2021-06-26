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
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(logInButtonWasTapped(_:)),
                         for: .touchUpInside)
        setUpCommonParametrs(for: button)
        return button
    }()
    private lazy var gotoRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зареристрироваться", for: .normal)
        button.addTarget(self, action: #selector(gotoRegisterButtonWasTapped(_:)),
                         for: .touchUpInside)
        setUpCommonParametrs(for: button)
        return button
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
    private lazy var buttonsStackView: UIStackView = {
        let button = UIButton()
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.setTitle("вход", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [
                                        logInButton,
                                        useBiometricButton,
                                        button ],
                                    axis: .vertical,
                                    spacing: AuthViewsParametrs.buttonsSpacing)
        return stackView
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
        textField.leftViewMode = .always
    }
    
    private func setUpCommonParametrs(for button: UIButton) {
        button.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        button.layer.shadowColor = AuthViewsParametrs.shadowColor
        button.layer.shadowRadius = AuthViewsParametrs.shadowRadius
        button.layer.shadowOpacity = AuthViewsParametrs.shadowOpacity
        button.layer.shadowOffset = .zero
        
        button.backgroundColor = AuthViewsParametrs.buttonBackgroundColor
        button.setTitleColor(AuthViewsParametrs.buttonTitleColor,
                             for: .normal)
    }
    
    private func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
    }
    
    private func configureUI() {
        let textFieldsStackView = UIStackView(arrangedSubviews: [loginTextField,
                                                                 passwordTextField ],
                                              axis: .vertical,
                                              spacing: AuthViewsParametrs.textFieldsSpacing)
        textFieldsStackView.layer.cornerRadius = AuthViewsParametrs.cornerRadius
        textFieldsStackView.backgroundColor = AuthViewsParametrs.textFieldBackgroundColor
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let shadowView = UIView()
        shadowView.layer.shadowOpacity = AuthViewsParametrs.shadowOpacity
        shadowView.layer.shadowRadius = AuthViewsParametrs.shadowRadius
        shadowView.layer.shadowOffset = AuthViewsParametrs.shadowOffset
        shadowView.layer.shadowColor = AuthViewsParametrs.shadowColor
        shadowView.layer.shadowPath = CGPath(rect: CGRect(x: 0, y: 0,
                                                          width: frame.width * 0.7,
                                                          height: textFieldsStackView.arrangedSubviews.reduce(0) { height, view in
                                                            if view is UITextField {
                                                                return height + AuthViewsParametrs.textFieldHeight
                                                            } else { return height }
                                                          }), transform: nil)
        shadowView.addSubview(textFieldsStackView)
    
        
        let mainStackView = UIStackView(arrangedSubviews: [
                                            shadowView,
                                            buttonsStackView ],
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
            
            loginTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.textFieldHeight),
            
            logInButton.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.buttonHeight),
            gotoRegisterButton.heightAnchor.constraint(equalToConstant: AuthViewsParametrs.buttonHeight),
            
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height * 0.4),
            mainStackView.widthAnchor.constraint(equalToConstant: frame.width * 0.7),
        ])
    }
    
    @objc private func login() {
        delegate?.textFieldDidEndEditing(loginTextField, login: "test@mail.ru")
        delegate?.textFieldDidEndEditing(passwordTextField, password: "QWEasd123")
        delegate?.logInButtonWasTapped()
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
                          duration: 0.5,
                          options: .transitionCrossDissolve) { [weak self] in
            guard let self = self else { return }
            self.buttonsStackView.insertArrangedSubview(self.gotoRegisterButton,
                                                        at: 1)
        }
    }
}
