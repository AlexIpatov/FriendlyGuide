//
//  RequestFactory.swift
//  FriendlyGuide
//
//  Created by Alexander Pelevinov on 24.05.2021.
//

import Foundation

final class RequestFactory {
    
    lazy var commonSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = false
        let manager = URLSession(configuration: configuration,
                                 delegate: nil,
                                 delegateQueue: .main)
        return manager
    }()
    
    private lazy var chatManager: QBChatManager = { QBChatManager() }()
    private lazy var localAuthManager: BiometricIDAuth = { BiometricIDAuth() }()
    private lazy var keychainManager: LocksmithKeychain = { LocksmithKeychain() }()
    
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
    
    
    
    func makeGetDialogsRequestFactory() -> GetDialogsRequestFactory {
        chatManager
    }
    
    func makeCreateGroupDialogRequestFactory() -> CreatePublicDialogRequestFactory {
        chatManager
    }
    
    
    
    func makeLocalAuthRequestFactory() -> LocalAuthRequestFactory {
        localAuthManager
    }
    
    func makeLogInRequestFactory() -> LogInRequestFactory {
        chatManager
    }
    
    func makeSignUpRequestFactory() -> SignUpRequestFactory {
        chatManager
    }
    
    
    
    func makeKeychainRequestFactory() -> KeychainRequestFactory {
        keychainManager
    }
}
