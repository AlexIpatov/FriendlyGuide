//
//  XCTestCaseExt.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 09.06.2021.
//

import XCTest
@testable import FriendlyGuide

extension XCTestCase {
//    func setupURLSessionStub<T: EndPointType>(from route: T, with data: Data) throws -> URLSession {
//        let url = try XCTUnwrap(route.url())
//        URLProtocolStub.testURLs = [url: data]
//        let config = URLSessionConfiguration.ephemeral
//        config.protocolClasses = [URLProtocolStub.self]
//        let session = URLSession(configuration: config)
//        return session
//    }
    
    func setupURLSessionStub(from url: URL?, with data: Data) throws -> URLSession {
        let url = try XCTUnwrap(url)
        URLProtocolStub.testURLs = [url: data]
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        return session
    }
    
    func clearURLSessionStubData() {
        URLProtocolStub.testURLs = [:]
    }
    
}
