//
//  RoutingPathTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class RoutingPathTests: XCTestCase {
    func test_url_caseGetToken_urlContainsBaseAccountUrl() {
        XCTAssertTrue(RoutingPath.getToken.url.absoluteString.contains(Environment.baseAccountUrl))
    }
    
    func test_url_caseStartAuthorization_urlContainsBaseAccountUrl() {
        XCTAssertTrue(RoutingPath.startAuthorization.url.absoluteString.contains(Environment.baseAccountUrl))
    }
    
    func test_url_caseSearch_urlContainsBaseAPIUrl() {
        XCTAssertTrue(RoutingPath.search.url.absoluteString.contains(Environment.baseApiUrl))
    }
    
    func test_url_caseGetTrack_urlContainsBaseAPIUrl() {
        XCTAssertTrue(RoutingPath.getTrack(id: "").url.absoluteString.contains(Environment.baseApiUrl))
    }
    
    func test_url_caseGetArtist_urlContainsBaseAPIUrl() {
        XCTAssertTrue(RoutingPath.getArtist(id: "").url.absoluteString.contains(Environment.baseApiUrl))
    }
}
