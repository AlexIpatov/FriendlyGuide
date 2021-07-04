//
//  Image+Fixture.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension Image {
    static func fixture(
        image: String = "",
        source: ImageSource = .fixture()
    ) -> Image {
        .init(image: image, source: source)
    }
}

