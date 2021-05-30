//
//  AuthViewConnectable.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 28.05.2021.
//

import Foundation

protocol AuthViewConnectable: AnyObject {
    func logIn()
    
    func changeLogin(on newLogin: String) -> Bool
    func changePassword(on newPassword: String) -> Bool
}
