//
//  ImageSource+Fixtures.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension ImageSource {
    static func fixture(
        link: String = "",
        name: String = ""
    ) -> ImageSource {
        .init(link: link, name: name)
    }
}
