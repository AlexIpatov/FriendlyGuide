//
//  KeychainRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 01.06.2021.
//

import Foundation

protocol KeychainRequest {
    var accountName: String { get }
    var key: String { get }
}

protocol KeychainRequestFactory: AnyObject {
    func save(request: KeychainRequest, value: Any) throws
    func get<T>(request: KeychainRequest) -> T?
}
