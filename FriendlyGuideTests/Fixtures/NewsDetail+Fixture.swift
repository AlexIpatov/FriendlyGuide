//
//  NewsDetail+Fixture.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 04.07.2021.
//

import Foundation
@testable import FriendlyGuide

extension NewsDetail {
    static func fixture(
        title: String = "",
        newsDescription: String = "",
        bodyText: String = "",
        images: [Image] = [.fixture()],
        firstSubtitle: String = "",
        boolSubtitle: Bool = true,
        publicationDate: Date = Date(timeIntervalSince1970: 0),
        siteURL: String = "",
        shortPlace: EventPlace = .fixture()
    ) -> NewsDetail {
        .init(title: title,
              newsDescription: newsDescription,
              bodyText: bodyText,
              images: images,
              firstSubtitle: firstSubtitle,
              boolSubtitle: boolSubtitle,
              publicationDate: publicationDate,
              siteURL: siteURL,
              shortPlace: shortPlace)
    }
}
