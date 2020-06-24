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
    
    var customUrl: String?
    var routingPath: RoutingPath = .startAuthorization
    var method: HTTPMethod = .get
    var headers: Headers = [:]
    var queryItems: [URLQueryItem] = [
        AuthorizationQueryItem.clientId.create(),
        AuthorizationQueryItem.responseType(type: Self.responseType).create(),
        AuthorizationQueryItem.redirectUri.create(),
        AuthorizationQueryItem.scope(scope: Self.userScope).create(),
        AuthorizationQueryItem.state(state: Self.state).create()
    ]
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalCacheData
    
    func getCompleteUrl() -> URL? {
        guard let urlString = generateRequest().url?.absoluteString else { return nil }
        var bodyComponents = URLComponents(string: urlString)
        bodyComponents?.queryItems = queryItems        
        return bodyComponents?.url
    }
}
