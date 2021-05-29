//
//  SignUpViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - UI components
    private lazy var signUpView: SignUpView = {
        return SignUpView()
    }()

    // MARK: - Properties


    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        //scrollMethods
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        signUpView.addGestureRecognizer(tapGesture)
    }
    override func loadView() {
        view = signUpView
    }
    //MARK: -  Methods
    func configureViewController() {
        self.title = ""
    }
    @objc private func loginButtonTapped() {
        print(#function)
    }
    @objc private func signUpButtonTapped() {
        print(#function)
    }

    // MARK: - keyboard methods
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0)
        signUpView.scrollView.contentInset = contentInsets
        signUpView.scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func hideKeyboard() {
        signUpView.endEditing(true)
    }
    @objc func keyboardWillHide(notification: Notification) {
        signUpView.scrollView.contentInset = UIEdgeInsets.zero
        signUpView.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
extension SignUpViewController {
    private func buttonsTargets() {
        signUpView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
}
// MARK: - SwiftUI
import SwiftUI

struct SignUpViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView().edgesIgnoringSafeArea(.all)
        }
    }
    struct ContainerView: UIViewControllerRepresentable {
        let loginVC = SignUpViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<SignUpViewControllerProvider.ContainerView>) -> SignUpViewController {
            return loginVC
        }
        func updateUIViewController(_ uiViewController: SignUpViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SignUpViewControllerProvider.ContainerView>) {

        }
    }
}
