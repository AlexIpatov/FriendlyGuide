//
//  URLPathParameterEncoderTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import XCTest
@testable import FriendlyGuide

class ParameterEncoderTests: XCTestCase {
    let url = URL(string: "https://kudago.com/public-api/v1.4/events")
    let param: Parameters = ["path" : 324567]
    
    func testURLPathParameterEncoder() throws {
        let encoder = URLPathParameterEncoder()
        var request = URLRequest(url: try XCTUnwrap(url))
        try encoder.encode(urlRequest: &request, with: param)
        
        XCTAssertEqual(request.url?.absoluteString, "https://kudago.com/public-api/v1.4/events/324567")
    }
}
