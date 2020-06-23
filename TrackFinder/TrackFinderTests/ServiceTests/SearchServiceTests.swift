//
//  SearchServiceTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class SearchServiceTests: XCTestCase {
    
    var mockService: SearchServiceProtocol?
    
    override func setUp() {
        super.setUp()
        self.mockService = SearchService()
    }
    
    override func tearDown() {
        self.mockService = nil
        super.tearDown()
    }
    
    func test_searchTrack_queryIsEmpty_returnFetchingError() {
        let apiManager = MockApiManager<SearchTrackResponse>()
        self.mockService?.apiManager = apiManager
        
        apiManager.injectData(data: nil, error: .fetchingError)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<SearchTrackResponse, NetworkError>?
        mockService?.searchTrack(query: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure(let error):
            XCTAssertEqual(error, .fetchingError)
        default:
            XCTFail()
        }
        
    }
    
    func test_searchTrack_queryHasExistingSong_returnResponseWithItem() {
        let apiManager = MockApiManager<SearchTrackResponse>()
        self.mockService?.apiManager = apiManager
        let item = TrackItem.getMock(name: "name")
        let expectedResponse = SearchTrackResponse.getMock(items: [item])
        
        apiManager.injectData(data: expectedResponse, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<SearchTrackResponse, NetworkError>?
        mockService?.searchTrack(query: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure:
            XCTFail()
        case .success(let searchResopnse):
            XCTAssertEqual(searchResopnse.tracks.items.first?.name, item.name)
        }
        
    }
    
    func test_searchTrack_queryHasNoExistingSong_returnNoResultError() {
        let apiManager = MockApiManager<SearchTrackResponse>()
        self.mockService?.apiManager = apiManager
        
        let expectedResponse = SearchTrackResponse.getMock(items: [])
        
        apiManager.injectData(data: expectedResponse, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<SearchTrackResponse, NetworkError>?
        mockService?.searchTrack(query: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure(let error):
            XCTAssertEqual(error, .noResults)
        default:
            XCTFail()
        }
    }
    
    func test_loadNextPage_nextPageIsNotNilAndHasItem_returnResponseWithItem() {
        let apiManager = MockApiManager<SearchTrackResponse>()
        self.mockService?.apiManager = apiManager
        let item = TrackItem.getMock(name: "name")
        let expectedResponse = SearchTrackResponse.getMock(items: [item])
        
        apiManager.injectData(data: expectedResponse, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<SearchTrackResponse, NetworkError>?
        mockService?.loadNextPage(nextPageUrl: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure:
            XCTFail()
        case .success(let searchResopnse):
            XCTAssertEqual(searchResopnse.tracks.items.first?.name, item.name)
        }
    }
    
    func test_loadNextPage_nextPageIsNil_returnFetchingError() {
        let apiManager = MockApiManager<SearchTrackResponse>()
        self.mockService?.apiManager = apiManager
        
        apiManager.injectData(data: nil, error: .fetchingError)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<SearchTrackResponse, NetworkError>?
        mockService?.loadNextPage(nextPageUrl: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure(let error):
            XCTAssertEqual(error, .fetchingError)
        default:
            XCTFail()
        }
    }
    
    func test_searchTrack_nextPageIsNotNilButNoExistingSong_returnNoResultError() {
        let apiManager = MockApiManager<SearchTrackResponse>()
        self.mockService?.apiManager = apiManager
        
        let expectedResponse = SearchTrackResponse.getMock(items: [])
        
        apiManager.injectData(data: expectedResponse, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<SearchTrackResponse, NetworkError>?
        mockService?.loadNextPage(nextPageUrl: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure(let error):
            XCTAssertEqual(error, .noResults)
        default:
            XCTFail()
        }
    }
}
