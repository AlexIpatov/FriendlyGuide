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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
