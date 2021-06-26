//
//  GetUserRequestFactory.swift
//  FriendlyGuide
//
//  Created by Валерий Макрогузов on 19.06.2021.
//

import Foundation

protocol GetUserRequestFactory {
    func loadUser(_ id: UInt,
                  completion: @escaping (User?) -> Void)
}
