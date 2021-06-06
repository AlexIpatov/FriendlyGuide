//
//  DetailSection.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import Foundation

enum DetailSection: Int, CaseIterable {
    case photos, description, moreInfo, place

    func description() -> String {
        switch self {
        case .photos:
            return "photos"
        case .description:
            return "description"
        case .moreInfo:
            return "moreInfo"
        case .place:
            return "place"
        }
    }
}
