//
//  TrackItemServiceTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class TrackItemServiceTests: XCTestCase {
    var mockService: TrackItemServiceProtocol?
    
    override func setUp() {
        super.setUp()
        self.mockService = TrackItemService()
    }
    
    override func tearDown() {
        self.mockService = nil
        super.tearDown()
    }
    
    func test_getTrackItem_invalidId_returnFetchingError() {
        let apiManager = MockApiManager<TrackItem>()
        self.mockService?.apiManager = apiManager
        
        apiManager.injectData(data: nil, error: .fetchingError)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<TrackItem, NetworkError>?
        mockService?.getTrackItem(id: .empty, completion: { result in
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
    
    func test_getTrackItem_validId_returnTrackItemForId() {
        let apiManager = MockApiManager<TrackItem>()
        self.mockService?.apiManager = apiManager
        
        let item = TrackItem.getMock(name: "name")
        apiManager.injectData(data: item, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<TrackItem, NetworkError>?
        mockService?.getTrackItem(id: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure:
            XCTFail()
        case .success(let foundItem):
            XCTAssertEqual(foundItem.name, item.name)
        }
    }
    
    func test_getArtist_invalidId_returnFetchingError() {
        let apiManager = MockApiManager<CompleteArtist>()
        self.mockService?.apiManager = apiManager
        
        apiManager.injectData(data: nil, error: .fetchingError)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<CompleteArtist, NetworkError>?
        mockService?.getArtist(id: .empty, completion: { result in
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
    
    func test_getArtists_validId_returnTrackItemForId() {
        let apiManager = MockApiManager<CompleteArtist>()
        self.mockService?.apiManager = apiManager
        
        let item = CompleteArtist.getMock()
        apiManager.injectData(data: item, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<CompleteArtist, NetworkError>?
        mockService?.getArtist(id: .empty, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure:
            XCTFail()
        case .success(let foundItem):
            XCTAssertEqual(foundItem.name, item.name)
        }
    }
}
