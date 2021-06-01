//
//  LogInView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

protocol LoginViewRepresentable {
    func showRegisterButton()
    func shake(_ textField: UITextField)
}

fileprivate struct Constants {
    static let cornerRadius: CGFloat = 10
    static let borderWidth: CGFloat = 2
    static let textFieldHeight: CGFloat = 40
    static let textFieldsButtonsSpacing: CGFloat = 30
    static let buttonsSpacing: CGFloat = 10
    static let textFieldsSpacing: CGFloat = 0
    
    static var placeholderInsetsView: UIView {
        UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                             size: CGSize(width: 10, height: 1)))
    }
}

final class LogInView: UIView {
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInButtonWasTapped(_:)),
                         for: .touchUpInside)
        
        return button
    }()
    private lazy var gotoRegisterButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = Constants.borderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.isHidden = true
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(gotoRegisterButtonWasTapped(_:)),
                         for: .touchUpInside)
        
        return button

    }()
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        
        textField.delegate = self
        textField.placeholder = "login"
        textField.leftView = Constants.placeholderInsetsView
        textField.leftViewMode = .always
        
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.delegate = self
        textField.placeholder = "password"
        textField.leftView = Constants.placeholderInsetsView
        textField.leftViewMode = .always
        
        return textField
    }()
    private lazy var useBiometricButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "faceid")?
                            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 50))), for: .normal)
        button.imageView?.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(useBiometricButtonWasTaped(_:)), for: .touchUpInside)
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
    
    private func configureUI() {
        let separatorView = UIView()
        separatorView.backgroundColor = .black
        separatorView.isUserInteractionEnabled = false
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [loginTextField, separatorView, passwordTextField],
                                              axis: .vertical,
                                              spacing: Constants.textFieldsSpacing)
        textFieldsStackView.layer.borderWidth = Constants.borderWidth
        textFieldsStackView.layer.borderColor = UIColor.black.cgColor
        textFieldsStackView.layer.cornerRadius = Constants.cornerRadius
        
        
        
        let buttonsStackView = UIStackView(arrangedSubviews: [logInButton, gotoRegisterButton, useBiometricButton],
                                           axis: .vertical,
                                           spacing: Constants.buttonsSpacing)
        
        
        
        let mainStackView = UIStackView(arrangedSubviews: [textFieldsStackView, buttonsStackView],
                                        axis: .vertical,
                                        spacing: Constants.textFieldsButtonsSpacing)
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
        
        NSLayoutConstraint.activate([
            loginTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.borderWidth),
            
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.widthAnchor.constraint(equalToConstant: frame.width * 0.7),
        ])
    }
    
    private func addGestureRecognizers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        addGestureRecognizer(tap)
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
    
    func shake(_ textField: UITextField) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        
        animation.fromValue = CGPoint(x: textField.center.x - 10,
                                      y: textField.center.y)
        
        animation.toValue = CGPoint(x: textField.center.x + 10,
                                    y: textField.center.y) 

        textField.layer.add(animation, forKey: "position")
    }
}
