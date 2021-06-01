//
//  DetailSection.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 01.06.2021.
//

import Foundation

enum DetailSection: Int, CaseIterable {
    case title, photos, description, moreInfo

    func description() -> String {
        switch self {
        case .title:
            return "title"
        case .photos:
            return "photos"
        case .description:
            return "description"
        case .moreInfo:
            return "moreInfo"
        }
    }
}
