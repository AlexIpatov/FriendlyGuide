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
    
    func testGetPlaces() throws {
        let data = try JSONEncoder().encode(model)
        let session = try setupURLSessionStub(from: endPoint, with: data)
        let expectation = self.expectation(description: "loading")
        var count = 0
        
        let request = GetPlaces(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb", showingSince: "1444385206") { response in
            switch response {
            case .failure(_):
                expectation.fulfill()
            case .success(let places):
                count = places.count
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(count, 10)
    }
    
    func testGetPlacesBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: endPoint, with: data)
        let expectation = self.expectation(description: "loading")
        var error: NetworkingError?
        
        let request = GetPlaces(encoder: encoder, sessionManager: session)
        request.load(cityTag: "spb", showingSince: "1444385206") { response in
            switch response {
            case .failure(let err):
                error = err
                expectation.fulfill()
            case .success(_):
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(error, NetworkingError.parsingError)
    }
}
