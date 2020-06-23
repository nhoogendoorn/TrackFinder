//
//  AuthenticationServiceTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class AuthenticationServiceTests: XCTestCase {
    
    var mockService: AuthenticationServiceProtocol?
    
    override func setUp() {
        super.setUp()
        self.mockService = AuthenticationService()
    }
    
    override func tearDown() {
        self.mockService = nil
        super.tearDown()
    }
    
    func test_getAccessToken_codeIsNil_returnPostingError() {
        let apiManager = MockApiManager<AuthTokenResponse>()
        self.mockService?.apiManager = apiManager
        apiManager.injectData(data: nil, error: .postingError)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<AuthTokenResponse, NetworkError>?
        
        mockService?.getAccessToken(code: nil, completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure(let error):
            XCTAssertEqual(error, .postingError)
        default:
            XCTFail()
        }
    }
    
    func test_getAccessToken_codeIsValid_returnAuthtokens() {
        let apiManager = MockApiManager<AuthTokenResponse>()
        self.mockService?.apiManager = apiManager
        let expectedResponse = AuthTokenResponse.getMock()
        
        apiManager.injectData(data: expectedResponse, error: nil)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<AuthTokenResponse, NetworkError>?
        
        mockService?.getAccessToken(code: "valid", completion: { result in
            response = result
            promise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        guard let foundResponse = response else { XCTFail(); return }
        
        switch foundResponse {
        case .failure:
            XCTFail()
        case .success(let successFulReponse):
            XCTAssertEqual(expectedResponse.accessToken, successFulReponse.accessToken)
            XCTAssertEqual(expectedResponse.refreshToken, successFulReponse.refreshToken)
            XCTAssertEqual(expectedResponse.authTokens.expirationDate.toString(),
                           successFulReponse.authTokens.expirationDate.toString())
        }
    }
    
    func test_getAccessToken_codeIsInvalid_returnFetchingError() {
        let apiManager = MockApiManager<AuthTokenResponse>()
        self.mockService?.apiManager = apiManager
                
        apiManager.injectData(data: nil, error: .fetchingError)
        
        let promise = expectation(description: "completion handler invoked")
        var response: Result<AuthTokenResponse, NetworkError>?
        
        mockService?.getAccessToken(code: "valid", completion: { result in
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
}
