//
//  GetNewsTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 16.06.2021.
//

import XCTest
@testable import FriendlyGuide

class GetNewsTests: XCTestCase {

    class GetNewsTests: XCTestCase {
        
        let endPoint = NewsListResource(cityTag: "spb")
        let model: NewsList = .fixture()
        let encoder = URLPathParameterEncoder()
        let url = URL(string: "https://kudago.com/public-api/v1.4/news?lang=ru&location=spb&actual_only=true&fields=id,publication_date,title,description,images&text_format=text")
        
        func testGetNews() throws {
            let data = try JSONEncoder().encode(model)
            let session = try setupURLSessionStub(from: url, with: data)
            let expectation = self.expectation(description: "loading")
            
            let request = GetNews(encoder: encoder, sessionManager: session)
            request.load(cityTag: endPoint.cityTag) { response in
                guard case let .success(result) = response
                else { XCTFail(); expectation.fulfill(); return  }
                XCTAssertEqual(result, self.model)
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1, handler: nil)
        }
        
        func testGetNewsBadData() throws {
            let data = Data("Wrong!".utf8)
            let session = try setupURLSessionStub(from: url, with: data)
            let expectation = self.expectation(description: "loading")
            
            let request = GetNews(encoder: encoder, sessionManager: session)
            request.load(cityTag: endPoint.cityTag) { response in
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

}
