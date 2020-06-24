//
//  RefreshTokenRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct RefreshTokenRequest: SpotifyRequest {
        
    var customUrl: String?
    var routingPath: RoutingPath = .getToken
    var headers: Headers = .generateBasicHeader()
    var queryItems: [URLQueryItem]
    var method: HTTPMethod = .post
    
    init(refreshToken: String) {
        let query = [
            AuthorizationQueryItem.grantType(type: .refreshToken).create(),
            AuthorizationQueryItem.refreshToken(token: refreshToken).create()
        ]
        self.queryItems = query
    }
}
