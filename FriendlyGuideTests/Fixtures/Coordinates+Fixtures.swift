//
//  Coordinates+Fixtures.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension Coordinates {
    static func fixture(
        lat: Double = 0.0,
        lon: Double = 0.0
    ) -> Coordinates {
        .init(lat: lat, lon: lon)
    }
}
