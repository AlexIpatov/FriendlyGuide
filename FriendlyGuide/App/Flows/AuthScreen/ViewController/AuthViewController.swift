//
//  AuthViewController.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 29.05.2021.
//

import UIKit

class AuthViewController: UIViewController {
    // MARK: - UI components
    private lazy var authView: AuthView = {
        return AuthView()
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
        authView.addGestureRecognizer(tapGesture)
    }
    override func loadView() {
        view = authView
    }
    //MARK: -  Methods
    func configureViewController() {
        self.title = ""
    }
    @objc private func loginButtonTapped() {
        print(#function)
    }
    @objc private func signUpButtonTapped() {
        
    }

    // MARK: - keyboard methods
    @objc func keyboardWillShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0)
        authView.scrollView.contentInset = contentInsets
        authView.scrollView.scrollIndicatorInsets = contentInsets
    }
    @objc func hideKeyboard() {
        authView.endEditing(true)
    }
    @objc func keyboardWillHide(notification: Notification) {
        authView.scrollView.contentInset = UIEdgeInsets.zero
        authView.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
extension AuthViewController {
    private func buttonsTargets() {
        authView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        authView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
}
// MARK: - SwiftUI
import SwiftUI

struct AuthViewControllerProvider: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView().edgesIgnoringSafeArea(.all)
            ContainerView().previewDevice("iPhone 8").edgesIgnoringSafeArea(.all)
            ContainerView().previewDevice("iPod touch (7th generation)").edgesIgnoringSafeArea(.all)
        }
    }
    struct ContainerView: UIViewControllerRepresentable {
        let loginVC = AuthViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) -> AuthViewController {
            return loginVC
        }
        func updateUIViewController(_ uiViewController: AuthViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AuthViewControllerProvider.ContainerView>) {

        }
    }
}
