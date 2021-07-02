//
//  GetPlaceDetailTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 15.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetPlaceDetailTests: XCTestCase {
    let encoder = URLPathParameterEncoder()
    let endPoint = PlaceDetailResource(id: 1)
    let model = PlaceDetail(title: "mock", placeDescription: "", firstSubtitle: "", boolSubtitle: false,
                            images: [], bodyText: "", secondSubtitle: nil, address: "", phone: "",
                            coords: Coordinates(lat: 0.0, lon: 0.0), subway: "", categories: [],
                            siteUrl: "")
    let url = URL(string:"https://kudago.com/public-api/v1.4/places/1?lang=ru&fields=title,body_text,coords,phone,address,timetable,subway,coords,description,images,categories,is_closed,site_url&expand=place&text_format=text")
 
    func testGetPlaceDetail() throws {
        let data = try? JSONEncoder().encode(model)
        guard let data = data else { return }
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")

        let r = GetPlaceDetail(encoder: encoder, sessionManager: session)
        r.load(id: 1) { response in
            switch response {
            case .success(let result):
                XCTAssertEqual(result, self.model)
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testGetPlaceDetailBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetPlaceDetail(encoder: encoder, sessionManager: session)
        request.load(id: 1) { response in
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
