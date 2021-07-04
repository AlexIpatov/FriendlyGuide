//
//  TravelScreenUITests.swift
//  FriendlyGuideUITests
//
//  Created by Александр Ипатов on 03.07.2021.
//

import XCTest

class TravelScreenUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testGoToTravelView() throws {
        let app = XCUIApplication()
        app.launch()

        let logInButton = app.buttons["fastLogInButton"].firstMatch
        XCTAssertTrue(logInButton.isHittable, "\(app.debugDescription)")
        logInButton.tap()

        let travelScreenView = app.otherElements["travelScreenView"].firstMatch
        XCTAssertTrue(travelScreenView.waitForExistence(timeout: 10))
    }
}
