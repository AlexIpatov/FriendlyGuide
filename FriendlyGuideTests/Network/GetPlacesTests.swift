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
    var session: URLSession?
    
    override func setUpWithError() throws {
        let url = try XCTUnwrap(endPoint.url())
        let data = try JSONEncoder().encode(model)
        URLProtocolStub.testURLs = [url: data]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        session = URLSession(configuration: config)
        
        
    }

    override func tearDownWithError() throws {}

    func testPlacesGetRequest() throws {
        let session = try XCTUnwrap(session)
        let request = GetPlaces(encoder: encoder, sessionManager: session)
        request.getPlaces(cityTag: "spb", showingSince: "1444385206") { response in
            switch response {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let places):
                XCTAssertEqual(places.count, 10)
            }
        }
    }
    
    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
