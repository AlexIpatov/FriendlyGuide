//
//  FriendlyGuideUITests.swift
//  FriendlyGuideUITests
//
//  Created by Валерий Макрогузов on 23.05.2021.
//

import XCTest

class FriendlyGuideUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let logInButton = app.buttons["fastLogInButton"].firstMatch
        XCTAssertTrue(logInButton.isHittable, "\(app.debugDescription)")
        logInButton.tap()

        let travelScreenView = app.otherElements["travelScreenView"].firstMatch
        XCTAssertTrue(travelScreenView.waitForExistence(timeout: 10))
        
        let mapScreenTabBarItem = app.tabBars.buttons["mapScreenTabBarItem"].firstMatch
        XCTAssertTrue(mapScreenTabBarItem.isHittable, "\(app.debugDescription)")
        XCTAssertTrue(mapScreenTabBarItem.waitForExistence(timeout: 10))
        mapScreenTabBarItem.tap()
            
        let mapScreenView = app.otherElements["mapScreenView"].firstMatch
        XCTAssertTrue(mapScreenView.waitForExistence(timeout: 10))
        
        let zoomInMapButton = app.buttons["zoomInMapButton"].firstMatch
        XCTAssertTrue(zoomInMapButton.isHittable, "\(app.debugDescription)")
        XCTAssertTrue(zoomInMapButton.waitForExistence(timeout: 10))
        zoomInMapButton.tap()

        let zoomOutMapButton = app.buttons["zoomOutMapButton"].firstMatch
        XCTAssertTrue(zoomOutMapButton.isHittable, "\(app.debugDescription)")
        XCTAssertTrue(zoomOutMapButton.waitForExistence(timeout: 10))
        zoomOutMapButton.tap()
        
        let startTrackingLocationButton = app.buttons["startTrackingLocationButton"].firstMatch
        XCTAssertTrue(startTrackingLocationButton.isHittable, "\(app.debugDescription)")
        XCTAssertTrue(startTrackingLocationButton.waitForExistence(timeout: 30))
        startTrackingLocationButton.tap()
      
        let showCurrentLocationButton = app.buttons["showCurrentLocationButton"].firstMatch
        XCTAssertTrue(showCurrentLocationButton.isHittable, "\(app.debugDescription)")
        XCTAssertTrue(showCurrentLocationButton.waitForExistence(timeout: 10))
        showCurrentLocationButton.tap()
    }
}
