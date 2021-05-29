//
//  AuthView.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import UIKit

class AuthView: UIView {
    // MARK: - UI components
    private(set) lazy var helloLabel = UILabel(text: "Добро пожаловать в чат!\n Авторизуйтесь для продолжения:",
                                               font: .titleFont(),
                                               textColor: .black,
                                               numberOfLines: 0,
                                               textAlignment: .center)
    private(set) lazy var signUpLabel = UILabel(text: "У Вас еще нет аккаунта?",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 1,
                                               textAlignment: .center)
    private(set) lazy var loginImageView = UIImageView(systemImageName: "person",
                                                       tintColor: .systemBlue)
    private(set) lazy var passwordImageView = UIImageView(systemImageName: "lock",
                                                          tintColor: .systemBlue)
    private(set) lazy var loginTextField = UITextField(placeholder: "Логин",
                                                       font: .smallTitleFont(),
                                                       borderStyle: .roundedRect)
    private(set) lazy var passwordTextField = UITextField(placeholder: "Пароль",
                                                       font: .smallTitleFont(),
                                                       borderStyle: .roundedRect)
    let loginButton = UIButton(title: "Войти",
                               font: .bigButtonFont(),
                               cornerRadius: 0,
                               backgroundColor: .clear,
                               tintColor: .systemBlue)
    let signUpButton = UIButton(title: "Регистриция",
                                font: .bigButtonFont(),
                                cornerRadius: 0,
                                backgroundColor:  .clear,
                                tintColor: .systemGray)
    let scrollView = UIScrollView(isScrollEnabled: true)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        backgroundColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration Methods
    func configureUI() {
        let loginStackView = UIStackView(arrangedSubviews: [loginImageView,
                                                               loginTextField],
                                            axis: .horizontal,
                                            spacing: 5)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordImageView,
                                                               passwordTextField],
                                            axis: .horizontal,
                                            spacing: 5)
        let stackView = UIStackView(arrangedSubviews: [loginStackView,
                                                       passwordStackView],
                                    axis: .vertical,
                                    spacing: 30)
        let signUpStackView = UIStackView(arrangedSubviews: [signUpLabel,
                                                             signUpButton],
                                    axis: .vertical,
                                    spacing: 10)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(helloLabel)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(signUpStackView)
        NSLayoutConstraint.activate([
            loginImageView.widthAnchor.constraint(equalTo: loginTextField.heightAnchor),
            loginImageView.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            passwordImageView.widthAnchor.constraint(equalTo: loginTextField.heightAnchor),
            passwordImageView.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),

            helloLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30),
            helloLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            helloLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            loginButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            signUpStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signUpStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            signUpStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
}


