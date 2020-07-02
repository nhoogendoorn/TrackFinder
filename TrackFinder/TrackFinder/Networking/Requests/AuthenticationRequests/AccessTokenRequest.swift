//
//  AccessTokenRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct AccessTokenRequest: SpotifyRequest {
    var customUrl: String?
    var routingPath: RoutingPath = .getAccessToken
    var headers: Headers = [:]
    var queryItems: [URLQueryItem]
    var method: HTTPMethod = .post
    
    init(code: String) {
        let query = [AuthorizationQueryItem.authCode(code: code).create()]
        self.queryItems = query
    }
}
