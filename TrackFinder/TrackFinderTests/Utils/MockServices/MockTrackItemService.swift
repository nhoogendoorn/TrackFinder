//
//  MockTrackItemService.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
@testable import TrackFinder

class MockTrackItemService: TrackItemServiceProtocol, MockServiceProtocol {
    var apiManager: ApiProtocol = MockApiManager<AuthTokenResponse>()
    
    func startSpotifyAuthorization() { }
    var data: Codable?
    var error: NetworkError?

    func getTrackItem(id: String, completion: @escaping (Result<TrackItem, NetworkError>) -> Void) {
        handleCompletion(data: data, completion: completion)
    }
    
    func getArtist(id: String, completion: @escaping (Result<CompleteArtist, NetworkError>) -> Void) {
        handleCompletion(data: data, completion: completion)
    }
}
