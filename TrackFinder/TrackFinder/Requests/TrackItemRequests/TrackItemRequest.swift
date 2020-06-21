//
//  TrackItemRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 21/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct TrackItemRequest: SpotifyRequest {
    var customUrl: String?
    var routingPath: RoutingPath
    var headers: Headers = .generateBearerHeader()
    var queryItems: [URLQueryItem] = []
    var method: HTTPMethod = .get
    
    init(id: String, limit: Int = SearchQueryItem.defaultLimit) {
        routingPath = .getTrack(id: id)
    }
}
