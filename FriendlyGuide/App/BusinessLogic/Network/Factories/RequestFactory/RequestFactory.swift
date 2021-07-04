//
//  RequestFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

final class RequestFactory {
    
    private let commonSession: URLSession
    
    init(commonSession: URLSession = URLSession.shared) {
        self.commonSession = commonSession
    }
    
    private lazy var chatManager: QBChatManager = { QBChatManager() }()
    private lazy var localAuthManager: BiometricIDAuth = { BiometricIDAuth() }()
    private lazy var keychainManager: LocksmithKeychain = { LocksmithKeychain() }()
    
    // MARK: - kudkudago methods:
    
    func makeGetCityNameFactory() -> GetCityNamesFactory {
        let encoder = URLPathParameterEncoder()
        return GetCityNames(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetCityDetailFactory() -> GetCityDetailFactory {
        let encoder = URLPathParameterEncoder()
        return GetCityDetail(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetEventsListFactory() -> GetEventsListFactory {
        let encoder = URLPathParameterEncoder()
        return GetEventsList(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetExpEventsListFactory() -> GetExpandedEventsListFactory {
        let encoder = URLPathParameterEncoder()
        return GetExpandedEventsList(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetEventDetailFactory() -> GetEventDetailFactory {
        let encoder = URLPathParameterEncoder()
        return GetEventDetail(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetNewsFactory() -> GetNewsFactory {
        let encoder = URLPathParameterEncoder()
        return GetNews(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetPlacesFactory() -> GetPlacesFactory {
        let encoder = URLPathParameterEncoder()
        return GetPlaces(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetPlaceDetailFactory() -> GetPlaceDetailFactory {
        let encoder = URLPathParameterEncoder()
        return GetPlaceDetail(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    func makeGetNewsDetailFactory() -> GetNewsDetailFactory {
        let encoder = URLPathParameterEncoder()
        return GetNewsDetail(encoder: encoder,
                           sessionManager: commonSession)
    }
    
    
    
    // MARK: - Chat

    func makeMessagesSender() -> MessagesSender {
        chatManager
    }
    
    func makeMessagesReader() -> MessagesReader {
        chatManager
    }
    
    func makeMessagesLoader() -> MessagesLoader {
        chatManager
    }
    
    
    
    func makeGetDialogsRequestFactory() -> DialogsLoader {
        chatManager
    }
    
    func makeCreateGroupDialogRequestFactory() -> DialogCreator {
        chatManager
    }
    
    func makeDialogDataLoader() -> DialogDataLoader {
        chatManager
    }
    
    func makeDialogActivator() -> DialogActivator {
        chatManager
    }
    
    
    // MARK: - User
    
    func makeGetUserRequestFactory() -> GetUserRequestFactory {
        chatManager
    }

    func makeGetCurrnetUserREquestFactory() -> CurrnetUserLoader {
        chatManager
    }
    
    
    //MARK: - Auth
    
    func makeLocalAuthRequestFactory() -> LocalAuthRequestFactory {
        localAuthManager
    }
    
    func makeLogInRequestFactory() -> LogInRequestFactory {
        chatManager
    }
    
    func makeSignUpRequestFactory() -> SignUpRequestFactory {
        chatManager
    }
    
    
    
    //MARK: - Keychain
    
    func makeKeychainRequestFactory() -> KeychainRequestFactory {
        keychainManager
    }
}
