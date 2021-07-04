//
//  News+Fixture.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension News {
    static func fixture(
        id: Int = 0,
        publicationDate: Int = 0,
        title: String = "",
        images: [Image] = [.fixture()],
        description: String = ""
    ) -> News {
        .init(id: id,
              publicationDate: publicationDate,
              title: title,
              images: images,
              description: description)
    }
}
