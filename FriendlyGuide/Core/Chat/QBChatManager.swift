//
//  QBChatManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.05.2021.
//

import Quickblox
import QuickbloxWebRTC

fileprivate struct CredentialsConstant {
    static let applicationID: UInt = 91313
    static let authKey = "Yh2848TZkhqwZmb"
    static let authSecret = "R35Jy7dq3fVOhre"
    static let accountKey = "bRRxx1asyn861G3JLPDP"
}

final class QBChatManager: ChatManager {
    
    static var instance: QBChatManager = {
        return QBChatManager()
    }()
    
    static func initialise() {
        QBSettings.applicationID = CredentialsConstant.applicationID
        QBSettings.authKey = CredentialsConstant.authKey
        QBSettings.authSecret = CredentialsConstant.authSecret
        QBSettings.accountKey = CredentialsConstant.accountKey
        
        // enabling carbons for chat
        QBSettings.carbonsEnabled = true
        
        // Enables Quickblox REST API calls debug console output.
        QBSettings.logLevel = .debug
        
        // Enables detailed XMPP logging in console output.
        QBSettings.enableXMPPLogging()
        QBSettings.disableFileLogging()
        QBSettings.autoReconnectEnabled = true
    }
    
    
    private func errorMessage(for response: QBResponse) -> String? {
        switch response.status {
        case .badRequest:
            return "SA_STR_BAD_GATEWAY"
        case .serverError:
            return "SA_STR_NETWORK_ERROR"
        default:
            return response.error?.error?
                .localizedDescription
        }
    }
}

// MARK: - ChatDialogsManager

extension QBChatManager: ChatDialogsManager {
    func createGroupDialog(withName name: String,
                           photo: String?,
                           occupants: [ChatConnectable],
                           completion: @escaping (_ dialog: Dialog?) -> Void) {
        
        let chatDialog = QBChatDialog(dialogID: nil, type: .group)
        
        chatDialog.name = name
        chatDialog.occupantIDs = occupants.map { NSNumber(value: $0.userID) }
        
        QBRequest.createDialog(chatDialog, successBlock: { response, qbdialog in
            qbdialog.join { error in
                if let error = error {
                    debugPrint("[ChatManager] createGroupDialog error:\(error.localizedDescription)")
                    completion(nil)
                } else {
                    //completion(dialog)
                }
            }
        }, errorBlock: { [weak self] response in
            debugPrint("[ChatManager] createGroupDialog error:\(self?.errorMessage(for: response) ?? "")")
        })
    }
    
    func getDialogs(limit: Int, skipFirst: Int, complition: @escaping (_ dialogs: [Dialog]) -> Void) {
        QBRequest.dialogs(for: QBResponsePage(limit: limit, skip: skipFirst),
                          extendedRequest: nil,
                          successBlock: { (response, dialogs, dialogsUsersIDs, page) in
                            
                            
                            
                          }, errorBlock: { [weak self] response in
                            debugPrint("[ChatManager] getAllUserDialog error:\(self?.errorMessage(for: response) ?? "")")
                          })
    }
}

// MARK: - ChatDialogsManager

extension QBChatManager: ChatUsersManager {
    
}

// MARK: - ChatDialogsManager

extension QBChatManager: ChatMessagesManager {
    
}

// MARK: - AuthenticatorManager

extension QBChatManager: AuthenticatorManager {
    func signUp(fullName: String, login: String, password: String,
                complition: @escaping (Result<Bool, Error>) -> Void) {
        let newQBUUser = QBUUser()
        newQBUUser.login = login
        newQBUUser.fullName = fullName
        newQBUUser.password = password
        
        QBRequest.signUp(newQBUUser, successBlock: { [weak self] response, user in
            guard let self = self else { return }
            
            
            self.login(login: login, password: password) { result in
                switch result {
                case .failure(let error):
                    complition(.failure(error))
                case .success(let result):
                    User.instance.fullName = fullName
                    complition(.success(result))
                }
            }
            
        }, errorBlock: { response in
            if response.status == QBResponseStatusCode.validationFailed {
                print("Validation faild!")
            }
            
            if let error = response.error?.error {
                complition(.failure(error))
            }
        })
    }
    
    func login(login: String, password: String,
               complition: @escaping (Result<Bool, Error>) -> Void) {
        QBRequest.logIn(withUserLogin: login, password: password) { [weak self] response, qbUser in
            
            User.instance.login = login
            User.instance.password = password
            
            qbUser.password = password
            self?.connectToChat(user: qbUser)
            complition(.success(true))
            
        } errorBlock: { response in
            print("Some problems with autentificate user")
            complition(.success(false))
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
