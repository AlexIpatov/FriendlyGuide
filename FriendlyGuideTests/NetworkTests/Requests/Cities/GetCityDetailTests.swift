//
//  GetCityDetailTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 16.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetCityDetailTests: XCTestCase {
    
    let endPoint = CityDetailResource(cityTag: "spb")
    let model = CityDetail(slug: "spb", name: "spb", timezone: "timezone",
                           coords: Coordinates(lat: 1.0, lon: 2.0),
                           language: "ru", currency: "ru")
    let encoder = URLPathParameterEncoder()
    let url = URL(string: "https://kudago.com/public-api/v1.4/locations/spb?lang=ru")
    
    func testGetCityDetail() throws {
        let data = try JSONEncoder().encode(model)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetCityDetail(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb") { response in
            guard case let .success(result) = response
            else { XCTFail(); expectation.fulfill(); return  }
            XCTAssertEqual(result, self.model)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCityDetailBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetCityDetail(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb") { response in
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
