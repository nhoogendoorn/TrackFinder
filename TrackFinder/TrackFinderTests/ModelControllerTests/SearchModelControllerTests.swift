//
//  SearchModelControllerTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class SearchModelControllerTests: XCTestCase {
    let mockSearchService = MockSearchService()
    lazy var sut: SearchModelController = {
        let modelController = SearchModelController()
        modelController.searchService = mockSearchService
        return modelController
    }()
    
    let twoResults = Tracks(href: .empty,
                            items: [TrackItem.getMock(name: "1"),
                                    TrackItem.getMock(name: "2")],
                            limit: 2, next: "nil", offset: 1, previous: nil, total: 1)
    
    func test_searchQuery_queryIsNil_dataIsEmpty() {
        mockSearchService.injectData(data: nil, error: nil)
        sut.searchQuery(query: nil)
        XCTAssertTrue(sut.data.isEmpty)
    }
    
    func test_searchQuery_queryIsNil_nextPageUrlIsNil() {
        mockSearchService.injectData(data: nil, error: nil)
        sut.searchQuery(query: nil)
        XCTAssertNil(sut.nextPageUrl)

    }
    
    func test_searchQuery_queryIsNil_errorPageIsNil() {
        mockSearchService.injectData(data: nil, error: nil)
        sut.searchQuery(query: nil)
        XCTAssertNil(sut.errorMessage)
    }

    func test_searchQuery_queryIsValidTwoResults_dataHasTwoItems() {
        let searchResponse = SearchTrackResponse(tracks: twoResults)
        mockSearchService.injectData(data: searchResponse, error: nil)
        sut.searchQuery(query: "valid")
        XCTAssertTrue(sut.data.count == 2)
    }
    
    func test_searchQuery_queryIsValidTwoResults_nextPageUrlIsFilled() {
        let searchResponse = SearchTrackResponse(tracks: twoResults)
        mockSearchService.injectData(data: searchResponse, error: nil)
        sut.searchQuery(query: "valid")
        XCTAssertNotNil(sut.nextPageUrl)
    }
    
    func test_searchQuery_queryIsValidTwoResults_errorPageIsNil() {
        let searchResponse = SearchTrackResponse(tracks: twoResults)
        mockSearchService.injectData(data: searchResponse, error: nil)
        sut.searchQuery(query: "valid")
        XCTAssertNil(sut.errorMessage)
    }
    
    func test_searchQuery_queryIsInvalid_dataIsEmpty() {
        let searchResponse = SearchTrackResponse(tracks: twoResults)
        mockSearchService.injectData(data: searchResponse, error: nil)
        sut.searchQuery(query: .empty)
        XCTAssertTrue(sut.data.isEmpty)
    }
    
    func test_searchQuery_queryIsInvalid_nextPageUrlIsNil() {
        let searchResponse = SearchTrackResponse(tracks: twoResults)
        mockSearchService.injectData(data: searchResponse, error: nil)
        sut.searchQuery(query: .empty)
        XCTAssertNil(sut.nextPageUrl)

    }
}
