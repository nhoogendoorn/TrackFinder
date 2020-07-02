//
//  URLRequestTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class URLRequestTests: XCTestCase {
    func test_addQuery_methodIsPost_queryIsInHttpBody() {
        let query = [SearchQueryItem.limit(10).create()]
        var urlRequest = URLRequest(routingPath: .getAccessToken)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        var urlComponents = URLComponents(url: urlRequest.url!, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = query
        let body = urlComponents?.query?.data(using: .utf8)
        urlRequest.addQuery(query: query)
        XCTAssertEqual(urlRequest.httpBody, body)
    }
    
    func test_addQuery_methodIsPost_queryIsNotInUrl() {
        let item = SearchQueryItem.limit(10).create()
        let query = [item]
        var urlRequest = URLRequest(routingPath: .getAccessToken)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.addQuery(query: query)
        XCTAssertFalse(urlRequest.url?.absoluteString.contains(item.value!) == true)
    }
    
    func test_addQuery_methodIsGet_queryIsInUrl() {
        let item = SearchQueryItem.limit(10).create()
        let query = [item]
        var urlRequest = URLRequest(routingPath: .getAccessToken)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addQuery(query: query)
        XCTAssertTrue(urlRequest.url?.absoluteString.contains(item.value!) == true)

    }
    
    func test_addQuery_methodIsGet_queryIsInNotInBody() {
        let item = SearchQueryItem.limit(10).create()
        let query = [item]
        var urlRequest = URLRequest(routingPath: .getAccessToken)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addQuery(query: query)
        XCTAssertNil(urlRequest.httpBody)

    }
}
