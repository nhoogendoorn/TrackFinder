//
//  AccessTokenRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct AccessTokenRequest: SpotifyRequest {
    typealias ResponseType = AuthTokenResponse
    
    var routingPath: RoutingPath = .getToken
    var headers: Headers = .basicAuthorizationHeader
    var queryItems: [URLQueryItem]
    var method: HTTPMethod = .post
    
    init(code: String) {
        let query = [
            SpotifyQueryItem.grantType(type: .authorization).create(),
            SpotifyQueryItem.authCode(code: code).create(),
            SpotifyQueryItem.redirectUri.create()            
        ]
        self.queryItems = query
    }
}
