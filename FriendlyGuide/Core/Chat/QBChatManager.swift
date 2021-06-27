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

enum QBChatManagerError: LocalizedError {
    case unknown
    case noDialogById
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Неизвестная ошибка"
        case .noDialogById:
            return "Нет такого диалога"
        }
        
    }
}

final class QBChatManager: NSObject {
    
    static var instance: QBChatManager = {
        let manager = QBChatManager()
        QBChat.instance.addDelegate(manager)
        return manager
    }()
    
    private var delegates = [String: ChatRoomDelegate]()
    
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
    
    deinit {
        QBChat.instance.removeAllDelegates()
    }
}

// MARK: - ChatDialogsManager

extension QBChatManager: DialogCreator {
    func createDialog(id: String,
                      name: String,
                      photo: String?,
                      completion: @escaping (Result<Dialog, Error>) -> Void) {
        
        let responsePage = QBResponsePage(limit: 1, skip: 0)
        let extendedReques = ["_id": id]
        
        QBRequest.dialogs(for: responsePage, extendedRequest: extendedReques, successBlock: { (_, dialogs, _, _) in
            if let qbDialog = dialogs.first {
                qbDialog.join { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        let dialog = Dialog(dialogId: qbDialog.id ?? "",
                                            dialogName: qbDialog.name ?? "")
                        completion(.success(dialog))
                    }
                }
            } else {
                let qbNewDialog = QBChatDialog(dialogID: id,
                                               type: .publicGroup)
                qbNewDialog.name = name
                qbNewDialog.photo = photo
                
                QBRequest.createDialog(qbNewDialog, successBlock: { response, qbDialog in
                    qbDialog.join { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            let dialog = Dialog(dialogId: qbDialog.id ?? "",
                                                dialogName: qbDialog.name ?? "")
                            completion(.success(dialog))
                        }
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
extension QBChatManager: DialogsLoader {
    func getDialogs(limit: Int,
                    skipFirst: Int,
                    completion: @escaping (Result<GetUserDialogsResponse, Error>) -> Void) {
        
        let responsePage = QBResponsePage(limit: limit, skip: skipFirst)
        let extendedRequest: [String: String]? = nil
        
        QBRequest.dialogs(for: responsePage, extendedRequest: extendedRequest, successBlock: { (_, qbDialogs, _, page) in
            
            let dialogs = qbDialogs
                .map { Dialog(dialogId: $0.id ?? "", dialogName: $0.name ?? "") }
            completion(.success((dialogs, Int(page.totalEntries))))
            
        }, errorBlock: { [weak self] response in
            debugPrint("[ChatManager] getAllUserDialog error:\(self?.errorMessage(for: response) ?? "")")
            completion(.failure(response.error?.error ?? QBChatManagerError.unknown))
        })
    }
}

extension QBChatManager: MessagesLoader {
    func messages(for dialog: Dialog,
                  skip: Int,
                  limit: Int,
                  extendedRequest extendedParameters: [String: String]?,
                  completion: @escaping (Result<GetMessagesResponse, Error>) -> Void) {
        
        let page = QBResponsePage(limit: limit, skip: skip)
        let extendedRequest = extendedParameters ?? [ "sort_desc": "date_sent",
                                                      "mark_as_read": "0" ]
        
        QBRequest.messages(withDialogID: dialog.dialogId, extendedRequest: extendedRequest, for: page,
                           successBlock: { response, messages, page in
                            let totalNumberOfMessages = Int(page.totalEntries)
                            let sortedMessages = messages
                                .reversed()
                                .map { Message(sentDate: $0.dateSent ?? Date(),
                                               messageSender: User(userID: $0.senderID),
                                               messageText: $0.text ?? "",
                                               messageId: $0.id ?? "",
                                               dialogId: $0.dialogID ?? "") }
                            
                            completion(.success((sortedMessages, totalNumberOfMessages)))
                           }, errorBlock: { response in
                            completion(.failure(response.error?.error ?? QBChatManagerError.unknown))
                           })
    }
}

extension QBChatManager: MessagesSender {
    func send(_ message: Message,
              in dialog: Dialog,
              completion: @escaping (Error?) -> Void) {
        
        let responsePage = QBResponsePage(limit: 1, skip: 0)
        let extendedRequest: [String: String]? = ["_id": dialog.dialogId]
        
        QBRequest.dialogs(for: responsePage, extendedRequest: extendedRequest, successBlock: { (_, qbDialogs, _, page) in
            if let qbDialog = qbDialogs.first {
                let qbMessage = QBChatMessage()
                qbMessage.text = message.messageText
                qbMessage.senderID = message.messageSender.userID
                qbMessage.dateSent = message.sentDate
                qbMessage.customParameters["save_to_history"] = true
                
                qbDialog.send(qbMessage) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        qbDialog.updatedAt = Date()
                        completion(nil)
                    }
                }
                
//                qbDialog.join { error in
//                    if let error = error { completion(error) }
//                    else {
//                        qbDialog.send(qbMessage) { (error) in
//                            if let error = error {
//                                completion(error)
//                            } else {
//                                qbDialog.updatedAt = Date()
//                                completion(nil)
//                            }
//                        }
//                    }
//                }
            }
        }, errorBlock: { [weak self] response in
            debugPrint("[ChatManager] getAllUserDialog error:\(self?.errorMessage(for: response) ?? "")")
            if let error = response.error?.error { completion(error) }
            else { completion(QBChatManagerError.unknown) }
        })
    }
    
    func send(_ messages: [Message],
              in dialog: Dialog,
              completion: @escaping (Error?) -> Void) {
        let messagesGroup = DispatchGroup()
        messages.forEach { message in
            messagesGroup.enter()
            send(message, in: dialog) { _ in
                messagesGroup.leave()
            }
        }
        
        messagesGroup.notify(queue: .main) {
            completion(nil)
        }
    }
}

extension QBChatManager: MessagesReader {
    func read(_ messages: [Message], dialog: Dialog, completion: @escaping (Error) -> Void) {
        
        let messagesId = messages
            .map { $0.messageId }
        
        QBRequest.markMessages(asRead: Set(messagesId), dialogID: dialog.dialogId) { response in
            response.error?.error
                .map { completion($0) }
        } errorBlock: { response in
            response.error?.error
                .map { completion($0) }
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
        
        QBRequest.signUp(newQBUUser, successBlock: { response, qbUser in
            
            let user = User(userID: qbUser.id,
                            userName: qbUser.fullName,
                            userLogin: qbUser.login,
                            userPassword: qbUser.password)
            completion(.success(user))
            
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
            
            qbUser.password = password
            self?.connectToChat(user: qbUser)
            
            let user = User(userID: qbUser.id,
                            userName: qbUser.fullName,
                            userLogin: qbUser.login,
                            userPassword: qbUser.password)
            
            completion(.success(user))
            
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

extension QBChatManager: GetUserRequestFactory {
    func loadUser(_ id: UInt,
                  completion: @escaping (User?) -> Void) {
        QBRequest.user(withID: id, successBlock: { (response, qbUser) in
            
            let user = User(userID: qbUser.id,
                            userName: qbUser.fullName,
                            userLogin: qbUser.login,
                            userPassword: qbUser.password)
    
            completion(user)
            
        }) { [weak self] response in
            debugPrint("[ChatManager] loadUser error: \(self?.errorMessage(for: response) ?? "")")
            completion(nil)
        }
    }
}

extension QBChatManager: CurrnetUserLoader {
    var currentUser: User? {
        QBSession.current.currentUser
            .map { User(userID: $0.id,
                        userName: $0.fullName,
                        userLogin: $0.login,
                        userPassword: $0.password) }
    }
}

extension QBChatManager: DialogDataLoader {
    func getLastMessageText(for dialog: Dialog,
                            completion: @escaping (Result<String, Error>) -> Void) {
        
        let responsePage = QBResponsePage(limit: 1, skip: 0)
        let extendedReques = ["_id": dialog.dialogId]
        
        QBRequest.dialogs(for: responsePage, extendedRequest: extendedReques) { _, dialogs, _, _ in
            if let dialog = dialogs.first {
                completion(.success(dialog.lastMessageText ?? ""))
            } else { completion(.failure(QBChatManagerError.noDialogById)) }
        } errorBlock: { response in
            response.error?.error
                .map{ completion(.failure($0)) }
        }
    }
    
    func getDialogImageURL(for dialog: Dialog,
                           completion: @escaping (Result<URL?, Error>) -> Void) {
        
        let responsePage = QBResponsePage(limit: 1, skip: 0)
        let extendedReques = ["_id": dialog.dialogId]
        
        QBRequest.dialogs(for: responsePage, extendedRequest: extendedReques) { _, dialogs, _, _ in
            if let dialog = dialogs.first {
                dialog.photo
                    .map { URL(string: $0) }
                    .map { completion(.success($0)) }
            } else { completion(.failure(QBChatManagerError.noDialogById)) }
        } errorBlock: { response in
            response.error?.error
                .map{ completion(.failure($0)) }
        }
    }
}

extension QBChatManager: DialogActivator {
    func join(to dialog: Dialog, completion: @escaping (Error?) -> Void) {
        
        let responsePage = QBResponsePage(limit: 1, skip: 0)
        let extendedReques = ["_id": dialog.dialogId]
        
        QBRequest.dialogs(for: responsePage, extendedRequest: extendedReques) { _, dialogs, _, _ in
            if let dialog = dialogs.first {
                dialog.join { $0.map { completion($0) } }
            } else { completion(QBChatManagerError.noDialogById) }
        } errorBlock: { response in
            if let error = response.error?.error {
                completion(error)
            } else { completion(QBChatManagerError.unknown) }
        }
    }
}

extension QBChatManager {
    func add(delegate: ChatRoomDelegate, for dialog: Dialog) {
        delegates[dialog.dialogId] = delegate
    }
}

extension QBChatManager: QBChatDelegate {
    func chatRoomDidReceive(_ message: QBChatMessage, fromDialogID dialogID: String) {
        if let delegate = delegates[dialogID] {
            
            QBRequest.user(withID: message.senderID) { _, sender in
                let messageSender = User(userID: sender.id,
                                         userName: sender.fullName,
                                         userLogin: sender.login,
                                         userPassword: sender.password)
                
                let message = Message(sentDate: message.dateSent ?? Date(),
                                      messageSender: messageSender,
                                      messageText: message.text ?? "",
                                      messageId: message.id ?? "",
                                      dialogId: dialogID)
                
                delegate.receive(message)
            } errorBlock: { response in
                debugPrint(response.error?.error ?? QBChatManagerError.unknown)
            }
        }
    }
}
