//
//  NewsList+Fixture.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension NewsList {
    static func fixture(
        count: Int = 0,
        next: String = "",
        previous: String = "",
        news: [News] = [.fixture()]
    ) -> NewsList {
        .init(count: count,
              next: next,
              previous: previous,
              news: news)
    }
}
