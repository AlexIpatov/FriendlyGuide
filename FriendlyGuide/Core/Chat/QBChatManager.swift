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

fileprivate enum QBChatManagerError: LocalizedError {
    case unknown
    
    var errorDescription: String? {
        "Неизвестная ошибка"
    }
}


final class QBChatManager {
    
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

extension QBChatManager: CreatePublicDialogRequestFactory {
    func createDialog(id: String,
                      name: String,
                      photo: String?,
                      completion: @escaping (Result<Dialog, Error>) -> Void) {
        
        QBRequest.dialogs(for: QBResponsePage(limit: 1, skip: 0),
                          extendedRequest: ["_id": id],
                          successBlock: { (_, dialogs, _, _) in
                            if let dialog = dialogs.first {
                                dialog.join { error in
                                    if let error = error { completion(.failure(error)) }
                                    else { completion(.success(dialog)) }
                                }
                            } else {
                                let dialog = QBChatDialog(dialogID: id,
                                                          type: .publicGroup)
                                dialog.name = name
                                dialog.photo = photo
                                
                                QBRequest.createDialog(dialog, successBlock: { response, dialog in
                                    dialog.join { error in
                                        if let error = error { completion(.failure(error)) }
                                        else { completion(.success(dialog)) }
                                    }
                                }, errorBlock: { response in
                                    response.error?.error.map { completion(.failure($0)) }
                                })
                            }
                          }, errorBlock: { response in
                            response.error?.error.map { completion(.failure($0)) }
                          })
    }
}

extension QBChatManager: GetUserDialogsRequestFactory {
    func getDialogs(limit: Int,
                    skipFirst: Int,
                    completion: @escaping (_ dialogs: [Dialog], _ total: Int) -> Void) {
        QBRequest.dialogs(for: QBResponsePage(limit: limit, skip: skipFirst),
                          extendedRequest: nil,
                          successBlock: { (_, dialogs, _, page) in
                            completion(dialogs, Int(page.totalEntries))
                          }, errorBlock: { [weak self] response in
                            debugPrint("[ChatManager] getAllUserDialog error:\(self?.errorMessage(for: response) ?? "")")
                          })
    }
}

extension QBChatManager: GetMessagesRequestFactory {
    func messages(for dialog: Dialog,
                  skip: Int,
                  limit: Int,
                  extendedRequest extendedParameters: [String : String]?,
                  successCompletion: MessagesCompletion?,
                  errorHandler: MessagesErrorHandler?) {
        
        let page = QBResponsePage(limit: limit, skip: skip)
        let extendedRequest = extendedParameters ?? [ "sort_desc": "date_sent",
                                                      "mark_as_read": "0" ]
        
        QBRequest.messages(withDialogID: dialog.dialogId,
                           extendedRequest: extendedRequest,
                           for: page,
                           successBlock: { response, messages, page in
                            var sortedMessages = messages
                            sortedMessages = Array(sortedMessages.reversed())
                            
                            let totalNumberOfMessages = Int(page.totalEntries)
                            successCompletion?(sortedMessages, totalNumberOfMessages)
        }, errorBlock: { response in
            // case where we may have deleted dialog from another device
            if response.status == .notFound || response.status.rawValue == 403 {
                
            }
            
            response.error?.error
                .map { errorHandler?($0) }
        })
    }
}

extension QBChatManager:SendMessagesRequestFactory {
    func send(_ message: QBChatMessage,
              in dialog: QBChatDialog,
              completion: @escaping (Error?) -> Void) {
        dialog.send(message) { (error) in
            if let error = error {
                completion(error)
            }
            dialog.updatedAt = Date()
            completion(nil)
        }
    }
}

extension QBChatMessage: ReadMessagesRequestFactory {
    func read(_ messages: [QBChatMessage],
              dialog: QBChatDialog,
              completion: @escaping (_ error: Error) -> Void) {
        
        let currentUser = User.instance
        let readGroup = DispatchGroup()
        
        messages.forEach { message in
            if message.dialogID != dialog.id { return }
            
            if message.deliveredIDs?.contains(NSNumber(value: currentUser.userID)) == false {
                QBChat.instance.mark(asDelivered: message) { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    debugPrint("mark as Delivered")
                }
            }
            
            readGroup.enter()
            QBChat.instance.read(message) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                if dialog.unreadMessagesCount > 0 {
                    dialog.unreadMessagesCount = dialog.unreadMessagesCount - 1
                }
                
                if UIApplication.shared.applicationIconBadgeNumber > 0 {
                    let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
                    UIApplication.shared.applicationIconBadgeNumber = badgeNumber - 1
                }
                
                readGroup.leave()
            }
        }
    }
}

// MARK: - AuthenticatorManager

extension QBChatManager: SignUpRequestFactory {
    func signUp(fullName: String, login: String, password: String,
                completion: @escaping (Result<User, Error>) -> Void) {
        let newQBUUser = QBUUser()
        newQBUUser.login = login
        newQBUUser.fullName = fullName
        newQBUUser.password = password
        
        QBRequest.signUp(newQBUUser, successBlock: { response, user in
            User.instance.fullName = fullName
            User.instance.password = password
            User.instance.login = login
            completion(.success(User.instance))
            
        }, errorBlock: { response in
            if response.status == QBResponseStatusCode.validationFailed {
                print("Validation faild!")
            }
            
            completion(.failure(response.error?.error ?? QBChatManagerError.unknown))
        })
    }
}

extension QBChatManager: LogInRequestFactory {
    func login(login: String, password: String,
               completion: @escaping (Result<User, Error>) -> Void) {
        QBRequest.logIn(withUserLogin: login, password: password) { [weak self] response, qbUser in
            
            User.instance.login = login
            User.instance.password = password
            
            qbUser.password = password
            self?.connectToChat(user: qbUser)
            completion(.success(User.instance))
            
        } errorBlock: { response in
            print("Some problems with autentificate user")
            completion(.failure(response.error?.error ?? QBChatManagerError.unknown))
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
