//
//  BasicAuthModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 30.05.2021.
//

import Foundation

struct BasicAuthModel {
    private var login: String = ""
    private var pasword: String = ""
}

extension BasicAuthModel: AuthModel {
    func update(password: String) -> Result<Bool, Error> {
        .success(true)
    }
    
    func update(login: String) -> Result<Bool, Error> {
        .success(true)
    }
    
    func getLogInData() -> (login: String, password: String) {
        ("", "")
    }
}
