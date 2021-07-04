//
//  DetailViewUITests.swift
//  FriendlyGuideUITests
//
//  Created by Александр Ипатов on 03.07.2021.
//

import XCTest

class DetailViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testGoToDetail() throws {
        let app = XCUIApplication()
        app.launch()
        let logInButton = app.buttons["fastLogInButton"].firstMatch
        XCTAssertTrue(logInButton.isHittable, "\(app.debugDescription)")
        logInButton.tap()
        let travelScreenView = app.otherElements["travelScreenView"].firstMatch
        XCTAssertTrue(travelScreenView.waitForExistence(timeout: 20))
        let travelScreenCollectionView = app.collectionViews["travelCollectionView"].firstMatch
        XCTAssertTrue(travelScreenCollectionView.waitForExistence(timeout: 20))
        travelScreenCollectionView.cells.element(boundBy: 0).tap()
        let detailView = app.otherElements["detailView"].firstMatch
        XCTAssertTrue(detailView.waitForExistence(timeout: 10))
    }

}
