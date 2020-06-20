//
//  AuthorizationRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct AuthorizationRequest: SpotifyRequest {    
    static let userScope = "user-read-private%20user-read-email"
    static let state = "34fFs29kd09"
    static let responseType = "code"
    
    var routingPath: RoutingPath = .startAuthorization
    var method: HTTPMethod = .get
    var headers: Headers = [:]
    var queryItems: [URLQueryItem] = [
        SpotifyQueryItem.clientId.create(),
        SpotifyQueryItem.responseType(type: Self.responseType).create(),
        SpotifyQueryItem.redirectUri.create(),
        SpotifyQueryItem.scope(scope: Self.userScope).create(),
        SpotifyQueryItem.state(state: Self.state).create()
    ]

    func getCompleteUrl() -> URL? {
        guard let urlString = generateRequest().url?.absoluteString else { return nil }
        var bodyComponents = URLComponents(string: urlString)
        bodyComponents?.queryItems = queryItems
        return bodyComponents?.url
    }
}