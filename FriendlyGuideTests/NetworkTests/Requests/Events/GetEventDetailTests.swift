//
//  GetEventsDetailTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 16.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetEventDetailTests: XCTestCase {

    let id = 1
    let model = EventDetail(title: "w", eventDescription: "", firstSubtitle: "", secondSubtitle: "", boolSubtitle: false, images: [], shortPlace: EventPlace(title: "", address: "", phone: "", subway: "", siteURL: "", isClosed: false, coords: Coordinates(lat: 0.0, lon: 0.0)), bodyText: "", dates: [], siteURL: "")
    var url: URL? { URL(string: "https://kudago.com/public-api/v1.4/events/\(id)?lang=ru&fields=title,place,body_text,price,age_restriction,categories,dates,images,site_url,is_free,description,short_title&expand=place&text_format=text") }
    let encoder = URLPathParameterEncoder()

    func testGetEventsList() throws {
        let data = try JSONEncoder().encode(model)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")

        let request = GetEventDetail(encoder: encoder, sessionManager: session)
        request.load(eventID: id) { response in
            guard case let .success(result) = response
            else { XCTFail(); expectation.fulfill(); return  }
            XCTAssertEqual(result, self.model)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testGetEventDetailBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")

        let request = GetEventDetail(encoder: encoder, sessionManager: session)
        request.load(eventID: id) { response in
            guard case let .failure(result) = response
            else { XCTFail(); expectation.fulfill(); return }
            XCTAssertEqual(result, NetworkingError.parsingError)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    override func tearDownWithError() throws {
        clearURLSessionStubData()
    }

}
