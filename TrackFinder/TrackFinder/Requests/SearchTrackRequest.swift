//
//  SearchTrackRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct SearchTrackRequest: SpotifyRequest {
    var customUrl: String?
    var routingPath: RoutingPath = .search
    var headers: Headers = .generateBearerHeader()
    var queryItems: [URLQueryItem]
    var method: HTTPMethod = .post
    
    init(query: String, nextPage: String? = nil, type: SearchQueryItem.SearchContentType, limit: Int = SearchQueryItem.defaultLimit) {
        self.customUrl = nextPage
        let query = [
            SearchQueryItem.query(query: query).create(),
            SearchQueryItem.contentType(type: type).create(),
            SearchQueryItem.limit(limit).create()
        ]
        self.queryItems = query
    }
}
