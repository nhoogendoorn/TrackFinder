//
//  MockSpotifyRequest.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
@testable import TrackFinder

struct MockRequest: SpotifyRequest {
    var routingPath: RoutingPath = .search
    var headers: Headers
    var queryItems: [URLQueryItem] = [SearchQueryItem.limit(10).create()]
    var method: HTTPMethod = .post
    var customUrl: String?
    
    init(customUrl: String? = nil, headers: Headers = .generateBearerHeader()) {
        self.customUrl = customUrl
        self.headers = headers
    }
    
}
