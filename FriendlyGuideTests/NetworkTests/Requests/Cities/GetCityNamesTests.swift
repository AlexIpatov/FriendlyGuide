//
//  GetCityNameTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 16.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetCityNamesTests: XCTestCase {
    
    let endPoint = CityNamesResource()
    let model = [CityName(slug: "spb", name: "spb")]
    let encoder = URLPathParameterEncoder()
    let url = URL(string: "https://kudago.com/public-api/v1.4/locations?lang=ru")
    func testGetCityNames() throws {
        let data = try JSONEncoder().encode(model)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetCityNames(encoder: encoder, sessionManager: session)
        request.load() { response in
            guard case let .success(result) = response
            else { XCTFail(); expectation.fulfill(); return  }
            XCTAssertEqual(result, self.model)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCityNamesBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetCityNames(encoder: encoder, sessionManager: session)
        request.load() { response in
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
