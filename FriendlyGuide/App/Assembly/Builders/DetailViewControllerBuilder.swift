//
//  DetailViewControllerBuilder.swift
//  FriendlyGuide
//
//  Created by Александр Ипатов on 26.06.2021.
//

import UIKit

final class DetailViewControllerBuilder {

    private let requestFactory: RequestFactory
    private let currentId: Int
    private let currentSectionType: TravelSection

    init(requestFactory: RequestFactory,
         currentId: Int,
         currentSectionType: TravelSection) {
        self.requestFactory = requestFactory
        self.currentId = currentId
        self.currentSectionType = currentSectionType
    }

    func build() -> UIViewController {
        DetailEventViewController(requestFactory: requestFactory,
                                  currentId: currentId,
                                  currentSectionType: currentSectionType)
    }
}
