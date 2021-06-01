//
//  AuthenticatorManager.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 26.05.2021.
//

protocol AuthenticatorManager {
    // create new user
    func signUp(fullName: String, login: String, password: String,
                complition: @escaping (Result<User, Error>) -> Void)
    
    //autorize exist user
    func login(login: String, password: String,
               complition: @escaping (Result<User, Error>) -> Void)
}
