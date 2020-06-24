//
//  AuthTokenTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 24/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class AuthTokenTests: XCTestCase {
    func test_isExpired_expirationDateIsIn11Minutes_returnFalse() {
        let authTokens = AuthTokens(accessToken: "1", refreshToken: "2", expirationDate: Date.now(.minute, offset: 11))
        XCTAssertFalse(authTokens.isExpired)
    }
    
    func test_isExpired_expirationDateIsIn10Minutes_returnTrue() {
        let authTokens = AuthTokens(accessToken: "1", refreshToken: "2", expirationDate: Date.now(.minute, offset: 10))
        XCTAssertTrue(authTokens.isExpired)
    }
    
    func test_isExpired_expirationDateIsIn10MinutesAgo_returnTrue() {
        let authTokens = AuthTokens(accessToken: "1", refreshToken: "2", expirationDate: Date.now(.minute, offset: -10))
        XCTAssertTrue(authTokens.isExpired)
    }
}
