//
//  ChatAuthenticatorManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.05.2021.
//

protocol ChatAuthenticatorManager {
    // create new user
    func signUp(newUser: ChatUser)
    
    //autorize exist user
    func login(user: ChatUser)
}
