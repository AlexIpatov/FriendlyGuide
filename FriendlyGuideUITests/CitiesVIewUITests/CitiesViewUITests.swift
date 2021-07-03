//
//  CitiesViewUITests.swift
//  FriendlyGuideUITests
//
//  Created by Александр Ипатов on 03.07.2021.
//

import XCTest

class CitiesViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testSelectCity() throws {
        let app = XCUIApplication()
        app.launch()
        let logInButton = app.buttons["fastLogInButton"].firstMatch
        XCTAssertTrue(logInButton.isHittable, "\(app.debugDescription)")
        logInButton.tap()
        let travelScreenView = app.otherElements["travelScreenView"].firstMatch
        XCTAssertTrue(travelScreenView.waitForExistence(timeout: 10))
        let cityNameButton = app.navigationBars["Путешествие"].buttons["cityNameView"].firstMatch
        XCTAssertTrue(cityNameButton.isHittable, "\(app.debugDescription)")
        XCTAssertTrue(cityNameButton.waitForExistence(timeout: 10))
        cityNameButton.tap()

        let cityView = app.otherElements["citiesView"].firstMatch
        XCTAssertTrue(cityView.waitForExistence(timeout: 10))
        let citiesTableView = app.tables["citiesTableView"].firstMatch

        citiesTableView.cells.staticTexts["Санкт-Петербург"].tap()
    }
}
