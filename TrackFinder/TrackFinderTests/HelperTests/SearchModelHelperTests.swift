//
//  SearchModelHelperTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class SearchModelHelperTests: XCTestCase {
    func test_allowedToStartSearch_queryIsNil_returnFalse() {
        let result = SearchModelHelper.allowedToStartSearch(query: nil)
        XCTAssertFalse(result)
    }
    
    func test_allowedToStartSearch_queryIsEmpty_returnFalse() {
        let result = SearchModelHelper.allowedToStartSearch(query: .empty)
        XCTAssertFalse(result)
    }
    
    func test_allowedToStartSearch_queryIsNotEmpty_returnTrue() {
        let result = SearchModelHelper.allowedToStartSearch(query: "Not empty")
        XCTAssertTrue(result)
    }
    
    func test_showBackground_dataIsEmpty_returnTrue() {
        let result = SearchModelHelper.showBackground(data: [])
        XCTAssertTrue(result)
    }
    
    func test_showBackground_dataIsNotEmpty_returnFalse() {
        let result = SearchModelHelper.showBackground(data: [TrackItem.getMock(name: "")])
        XCTAssertFalse(result)
    }
    
    func test_getErrorMessage_errorIsNoResults_returnCorrectMessage() {
        let result = SearchModelHelper.getErrorMessage(.noResults)
        XCTAssertEqual(result, .noTracksFound)
    }
    
    func test_getErrorMessage_errorIsNotNoResults_returnCorrectMessage() {
        let result = SearchModelHelper.getErrorMessage(.fetchingError)
        XCTAssertEqual(result, .generalError)
    }
    
    func test_showNoConnectionAlert_currentStateTrueNewStateTrue_returnFalse() {
        let result = SearchModelHelper.showNoConnectionAlert(true, true)
        XCTAssertFalse(result)
    }
    
    func test_showNoConnectionAlert_currentStateTrueNewStateFalse_returnTrue() {
        let result = SearchModelHelper.showNoConnectionAlert(true, false)
        XCTAssertTrue(result)
    }
    
    func test_showNoConnectionAlert_currentStateFalseNewStateTrue_returnFalse() {
        let result = SearchModelHelper.showNoConnectionAlert(false, true)
        XCTAssertFalse(result)
    }
    
    func test_showNoConnectionAlert_currentStateFalseNewStateFalse_returnFalse() {
        let result = SearchModelHelper.showNoConnectionAlert(false, false)
        XCTAssertFalse(result)
    }
}
