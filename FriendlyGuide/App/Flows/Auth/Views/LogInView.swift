//
//  LogInView.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import UIKit

class LogInView: UIView {
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Log In", for: .normal)
        button.addTarget(self, action: #selector(logInButtonWasTapped(_:)),
                         for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var gotoRegisterButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(gotoRegisterButtonWasTapped(_:)),
                         for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button

    }()
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        
        textField.delegate = self
        textField.placeholder = "login"
        textField.borderStyle = .bezel
        textField.layer.cornerRadius = 10
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        
        textField.delegate = self
        textField.placeholder = "password"
        textField.borderStyle = .bezel
        textField.layer.cornerRadius = 10
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    weak var delegate: LogInViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addGestureRecognizers()
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
    
    private func configureUI() {
        self.backgroundColor = .white
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [loginTextField,
                                                                 passwordTextField])
        textFieldsStackView.axis = .vertical
        textFieldsStackView.alignment = .fill
        textFieldsStackView.distribution = .equalSpacing
        textFieldsStackView.spacing = 10
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [textFieldsStackView,
                                                           logInButton,
                                                           gotoRegisterButton])
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 30
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
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
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        checkValidation(for: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func checkValidation(for textField: UITextField) -> Bool {
        let updateResult: Bool?
        
        if textField === passwordTextField {
            updateResult = delegate?.update(password: textField.text ?? "")
        } else {
            updateResult = delegate?.update(login: textField.text ?? "")
        }
        
        return updateResult ?? false
    }
}
