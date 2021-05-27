//
//  QBChatAuthentificator.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.05.2021.
//

import Foundation
import Quickblox

class QBChatAuthenticator: ChatAuthenticator {
    
    static let instance: ChatAuthenticator = {
        return QBChatAuthenticator()
    }()
    
    func signUp(newUser: ChatUser) {
        let newQBUUser = QBUUser()
        newQBUUser.login = newUser.login
        newQBUUser.fullName = newUser.fullName
        newQBUUser.password = newUser.password
        
        QBRequest.signUp(newQBUUser, successBlock: { [weak self] response, user in
            guard let self = self else { return }
            self.login(user: newUser)
            
        }, errorBlock: { response in
            if response.status == QBResponseStatusCode.validationFailed {
                print("Validation faild!")
                return
            }
        })
    }
    
    func login(user: ChatUser) {
        QBRequest.logIn(withUserLogin: user.login, password: user.password) { [weak self] response, qbUser in
            
            qbUser.password = user.password
            self?.connectToChat(user: qbUser)
            
        } errorBlock: { response in
            print("Some problems with autentificate user")
        }
    }
    
    private func connectToChat(user: QBUUser) {
        if QBChat.instance.isConnected == true {
            print("uset already connected to the chat server")
            
        } else {
            QBChat.instance.connect(withUserID: user.id, password: user.password ?? "") { error in
                if let error = error {
                    if error._code == QBResponseStatusCode.unAuthorized.rawValue {
                        print("user is unAuthorized")
                    } else {
                        print(error.localizedDescription)
                    }
                } else {
                    print("Sucsess connected to the chat server")
                }
            }
        }
    }
}
