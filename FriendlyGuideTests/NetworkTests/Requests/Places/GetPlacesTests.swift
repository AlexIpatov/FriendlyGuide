//
//  GetPlacesTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 08.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetPlacesTests: XCTestCase {
    
    let endPoint = PlacesListResource(cityTag: "spb", showingSince: "1444385206")
    let model = PlacesList(count: 10, next: nil, previous: nil, places: [])
    let encoder = URLPathParameterEncoder()
    let url = URL(string: "https://kudago.com/public-api/v1.4/places?lang=ru&location=spb&showing_since=1444385206&fields=id,title,coords,address,images,subway,location")
 
    func testGetPlaces() throws {
        let data = try JSONEncoder().encode(model)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetPlaces(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb", showingSince: "1444385206") { response in
            guard case let .success(result) = response
            else { XCTFail(); expectation.fulfill(); return  }
            XCTAssertEqual(result, self.model)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetPlacesBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetPlaces(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb", showingSince: "1444385206") { response in
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
