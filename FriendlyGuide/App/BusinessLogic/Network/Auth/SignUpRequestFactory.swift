//
//  SignUpRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 09.06.2021.
//

import Foundation

protocol SignUpRequestFactory {
    func signUp(fullName: String, login: String, password: String,
                completion: @escaping (Result<User, Error>) -> Void)
}
