//
//  AuthModel.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol AuthModel {
    func update(password: String) -> Result<Bool, Error>
    func update(login: String) -> Result<Bool, Error>
    
    func getLogInData() -> (login: String, password: String)
}
