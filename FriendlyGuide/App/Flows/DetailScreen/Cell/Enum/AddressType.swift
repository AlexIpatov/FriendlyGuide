//
//  AddressType.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 14.06.2021.
//

import Foundation

enum AddressType {
    case address, subway, phone
    func description() -> String {
        switch self {
        case .address:
            return "адрес:"
        case .subway:
            return "м."
        case .phone:
            return "тел.:"
        }
    }
}
