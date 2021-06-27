//
//  GetNewsDetailTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 16.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetNewsDetailTests: XCTestCase {
    let encoder = URLPathParameterEncoder()
    let endPoint = NewsDetailResource(id: 1)
    let model = NewsDetail(publicationDate: Date(), title: "title",
                           place: EventPlace(title: "place", address: "adress", phone: "phone",
                                             subway: nil, siteURL: "url",
                                             isClosed: true, coords: Coordinates(lat: 1.0, lon: 2.0)),
                           description: nil, bodyText: nil,
                           images: [], siteURL: "url")
    let url = URL(string: "https://kudago.com/public-api/v1.4/news/1?lang=ru&expand=place&text_format=text&fields=publication_date,title,description,images,site_url,place,body_text")

//    func testGetNewsDetail() throws {
//        let data = try? JSONEncoder().encode(model)
//        guard let data = data else { return }
//        let session = try setupURLSessionStub(from: url, with: data)
//        let expectation = self.expectation(description: "loading")
//
//        let request = GetNewsDetail(encoder: encoder, sessionManager: session)
//        request.load(id: 1) { response in
//            guard case let .success(result) = response
//            else { XCTFail(); expectation.fulfill(); return  }
//            XCTAssertEqual(result, self.model)
//            expectation.fulfill()
//        }
//        waitForExpectations(timeout: 2, handler: nil)
//    }
    
    func testGetNewsDetailBadData() throws {
        let data = Data("Wrong!".utf8)
        let session = try setupURLSessionStub(from: url, with: data)
        let expectation = self.expectation(description: "loading")
        
        let request = GetNewsDetail(encoder: encoder, sessionManager: session)
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
