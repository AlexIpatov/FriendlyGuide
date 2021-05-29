//
//  SignUpView.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import UIKit

class SignUpView: UIView {
    // MARK: - UI components
    private(set) lazy var loginLabel = UILabel(text: "У вас уже есть аккаунт?",
                                               font: .smallTitleFont(),
                                               textColor: .black,
                                               numberOfLines: 1,
                                               textAlignment: .center)
    private(set) lazy var loginImageView = UIImageView(systemImageName: "person",
                                                       tintColor: .systemBlue)
    private(set) lazy var passwordImageView = UIImageView(systemImageName: "lock",
                                                          tintColor: .systemBlue)
    private(set) lazy var confirmPasswordImageView = UIImageView(systemImageName: "lock.fill",
                                                          tintColor: .systemBlue)
    private(set) lazy var fullNameImageView = UIImageView(systemImageName: "pencil",
                                                         tintColor: .systemBlue)
    private(set) lazy var loginTextField = UITextField(placeholder: "Логин",
                                                       font: .smallTitleFont(),
                                                       borderStyle: .roundedRect)
    private(set) lazy var fullNameTextField = UITextField(placeholder: "Ваше полное имя",
                                                       font: .smallTitleFont(),
                                                       borderStyle: .roundedRect)
    private(set) lazy var passwordTextField = UITextField(placeholder: "Пароль",
                                                       font: .smallTitleFont(),
                                                       borderStyle: .roundedRect)
    private(set) lazy var confirmPasswordTextField = UITextField(placeholder: "Повторите пароль",
                                                       font: .smallTitleFont(),
                                                       borderStyle: .roundedRect)
    let loginButton = UIButton(title: "Войти",
                               font: .bigButtonFont(),
                               cornerRadius: 0,
                               backgroundColor: .clear,
                               tintColor: .systemGray)
    let signUpButton = UIButton(title: "Регистриция",
                                font: .bigButtonFont(),
                                cornerRadius: 0,
                                backgroundColor:  .clear,
                                tintColor: .blue)
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
    private func layoutForImages(imageVeiws: [UIImageView]) {
        imageVeiws.forEach({ (image) in
            NSLayoutConstraint.activate([
                image.widthAnchor.constraint(equalTo: loginTextField.heightAnchor),
                image.heightAnchor.constraint(equalTo: loginTextField.heightAnchor)
            ])
        })
    }
    func configureUI() {
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameImageView,
                                                               fullNameTextField],
                                         axis: .horizontal,
                                         spacing: 5)
        let loginStackView = UIStackView(arrangedSubviews: [loginImageView,
                                                            loginTextField],
                                         axis: .horizontal,
                                         spacing: 5)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordImageView,
                                                               passwordTextField],
                                            axis: .horizontal,
                                            spacing: 5)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordImageView,
                                                                      confirmPasswordTextField],
                                                   axis: .horizontal,
                                                   spacing: 5)
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView,
                                                       loginStackView,
                                                       passwordStackView,
                                                       confirmPasswordStackView],
                                    axis: .vertical,
                                    spacing: 30)
        let goToLoginStackView = UIStackView(arrangedSubviews: [loginLabel,
                                                             loginButton],
                                          axis: .vertical,
                                          spacing: 10)
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(signUpButton)
        scrollView.addSubview(goToLoginStackView)
        layoutForImages(imageVeiws: [loginImageView,
                                     passwordImageView,
                                     confirmPasswordImageView,
                                     fullNameImageView])
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),

            signUpButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            goToLoginStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            goToLoginStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            goToLoginStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
}
