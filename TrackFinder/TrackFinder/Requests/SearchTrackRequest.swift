//
//  SearchTrackRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct SearchTrackRequest: SpotifyRequest {
    var routingPath: RoutingPath = .search
    var headers: Headers = .generateBasicHeader()
    var queryItems: [URLQueryItem]
    var method: HTTPMethod = .post
    
    init(refreshToken: String) {
        let query = [
            SpotifyQueryItem.grantType(type: .refreshToken).create(),
            SpotifyQueryItem.refreshToken(token: refreshToken).create()
        ]
        self.queryItems = query
    }
}
