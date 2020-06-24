//
//  SpotifyRequestTests.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class SpotifyRequestTests: XCTestCase {
    func test_generateRequest_hasCustomUrl_ignoresGivenQueryItems() {
        let mockRequest = MockRequest(customUrl: "https://www.trackfinder.com").generateRequest()
        XCTAssertNil(mockRequest.httpBody)
    }
    
    func test_generateRequest_hasCustomUrl_ignoresBaseApiUrl() {
        let mockRequest = MockRequest(customUrl: "https://www.trackfinder.com").generateRequest()
        XCTAssertFalse(mockRequest.url?.absoluteString.contains(Environment.baseApiUrl) == true)
    }
    
    func test_generateRequest_hasCustomUrl_containsGivenHeaders() {
        let mockSpotifyRequest = MockRequest(customUrl: "https://www.trackfinder.com")
        let request = mockSpotifyRequest.generateRequest()
        XCTAssertEqual(request.allHTTPHeaderFields, mockSpotifyRequest.headers)
    }
    
    func test_generateRequest_hasCustomUrl_containsGivenMethod() {
        let mockSpotifyRequest = MockRequest(customUrl: "https://www.trackfinder.com")
        let request = mockSpotifyRequest.generateRequest()
        XCTAssertEqual(request.httpMethod, mockSpotifyRequest.method.rawValue)
    }
    
    func test_generateRequest_hasNoCustomUrl_containsGivenQueryItems() {
        let mockRequest = MockRequest(customUrl: nil).generateRequest()
        XCTAssertNotNil(mockRequest.httpBody)
        
    }
    
    func test_generateRequest_hasNoCustomUrl_containsBaseAPIUrl() {
        let mockRequest = MockRequest(customUrl: nil).generateRequest()
        XCTAssertTrue(mockRequest.url?.absoluteString.contains(Environment.baseApiUrl) == true)
    }
    
    func test_generateRequest_hasNoCustomUrl_containsGivenHeaders() {
        let mockSpotifyRequest = MockRequest(customUrl: nil)
        let request = mockSpotifyRequest.generateRequest()
        XCTAssertEqual(request.allHTTPHeaderFields, mockSpotifyRequest.headers)
    }
    
    func test_generateRequest_hasNoCustomUrl_containsGivenMethod() {
        let mockSpotifyRequest = MockRequest(customUrl: nil)
        let request = mockSpotifyRequest.generateRequest()
        XCTAssertEqual(request.httpMethod, mockSpotifyRequest.method.rawValue)
    }
    
    func test_setAccessToken_newHeaderHasNewToken() {
        let oldToken = "OldToken"
        let oldHeaders: Headers = .generateBearerHeader(with: oldToken)
        let newToken = "NewToken"
        let newHeaders: Headers = .generateBearerHeader(with: newToken)
        var mockSpotifyRequest = MockRequest(headers: oldHeaders)
        XCTAssertEqual(mockSpotifyRequest.headers["Authorization"], oldHeaders["Authorization"])
        
        mockSpotifyRequest.setAccessToken(token: newToken)
        XCTAssertEqual(mockSpotifyRequest.headers["Authorization"], newHeaders["Authorization"])
    }
}
