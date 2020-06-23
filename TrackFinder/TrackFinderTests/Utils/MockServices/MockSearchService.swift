//
//  MockSearchService.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
@testable import TrackFinder

class MockSearchService: SearchServiceProtocol, MockServiceProtocol {
    var apiManager: ApiProtocol = MockApiManager<AuthTokenResponse>()
    
    func startSpotifyAuthorization() { }
    var data: Codable?
    var error: NetworkError?

    func searchTrack(query: String, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void) {
        handleCompletion(data: data, completion: completion)
    }
    
    func loadNextPage(nextPageUrl: String?, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void) {
        handleCompletion(data: data, completion: completion)
    }
}
