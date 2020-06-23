//
//  QueueHelperTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class QueueHelperTests: XCTestCase {
    func test_shouldSuspendQueue_hasInternetTokenIsNotExpired_returnFalse() {
        let queue = ApiOperationQueue()
        queue.hasInternetConnection = true
        queue.currentAccessToken = AuthTokens.getMock(expired: false)
        let result = QueueHelper.shouldSuspendQueue(queue)
        XCTAssertFalse(result)
    }
    
    func test_shouldSuspendQueue_hasNoInternetTokenIsNotExpired_returnTrue() {
        let queue = ApiOperationQueue()
        queue.hasInternetConnection = false
        queue.currentAccessToken = AuthTokens.getMock(expired: false)
        let result = QueueHelper.shouldSuspendQueue(queue)
        XCTAssertTrue(result)
    }
    
    func test_shouldSuspendQueue_hasInternetTokenIsExpired_returnTrue() {
        let queue = ApiOperationQueue()
        queue.hasInternetConnection = true
        queue.currentAccessToken = AuthTokens.getMock(expired: true)
        let result = QueueHelper.shouldSuspendQueue(queue)
        XCTAssertTrue(result)
    }
    
    func test_shouldSuspendQueue_hasNotInternetTokenIsExpired_returnTrue() {
        let queue = ApiOperationQueue()
        queue.hasInternetConnection = false
        queue.currentAccessToken = AuthTokens.getMock(expired: true)
        let result = QueueHelper.shouldSuspendQueue(queue)
        XCTAssertTrue(result)
    }
}
