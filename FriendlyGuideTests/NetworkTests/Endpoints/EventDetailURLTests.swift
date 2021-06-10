//
//  EventDetailURLTests.swift
//  FriendlyGuideTests
//
//  Created by Alexander Pelevinov on 10.06.2021.
//

import XCTest
@testable import FriendlyGuide

class EventDetailURLTests: XCTestCase {
    
    let url = URL(string: "https://kudago.com/public-api/v1.4/events?lang=ru&fields=title,place,body_text,price,age_restriction,categories,dates,images,site_url,is_free,description,short_title&expand=place&text_format=text")
    let endPoint = EventDetailResource(eventID: 192527)

    func testMakeURL() throws {
        let result = endPoint.url()
        
        XCTAssertEqual(result, url)
    }
    
}
