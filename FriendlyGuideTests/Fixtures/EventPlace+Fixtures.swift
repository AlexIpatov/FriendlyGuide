//
//  EventPlace+Fixtures.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension EventPlace {
    static func fixture(
        title: String = "",
        address: String = "",
        phone: String = "",
        subway: String = "",
        siteURL: String = "",
        isClosed: Bool = true,
        coords: Coordinates = .fixture(),
        location: String = ""
    ) -> EventPlace {
        .init(title: title,
              address: address,
              phone: phone,
              subway: subway,
              siteURL: siteURL,
              isClosed: isClosed,
              coords: coords,
              location: location)
    }
}
