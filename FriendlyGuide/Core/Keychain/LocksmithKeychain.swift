//
//  LocksmithKeychain.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 01.06.2021.
//

import Foundation

import Foundation
import Locksmith

final class LocksmithKeychain: KeychainRequestFactory {
    func save(request: KeychainRequest, value: Any) throws {
        try Locksmith.saveData(data: [request.key: value], forUserAccount: request.accountName)
    }
    
    func get<T>(request: KeychainRequest) -> T? {
        Locksmith.loadDataForUserAccount(userAccount: request.accountName)?[request.key] as? T
    }
}
