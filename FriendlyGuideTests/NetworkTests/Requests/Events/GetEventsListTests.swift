//
//  GetEventsListTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 16.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetEventsListTests: XCTestCase {
    let url = URL(string: "https://kudago.com/public-api/v1.4/events?lang=ru&location=spb&actual_since=1444385206&fields=id,title,images,dates,place")
    let endPoint = EventsListResource(cityTag: "spb", actualSince: "1444385206")
    let model = EventsList(count: 11, next: nil, previous: nil, results: [])
    let encoder = URLPathParameterEncoder()
    
    func testGetEventsList() throws {
        let data = try JSONEncoder().encode(model)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetEventsList(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb", actualSince: "1444385206") { response in
            guard case let .success(result) = response
            else { XCTFail(); expectation.fulfill(); return  }
            XCTAssertEqual(result, self.model)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetEventsBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetEventsList(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb", actualSince: "1444385206") { response in
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
