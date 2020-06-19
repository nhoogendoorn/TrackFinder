//
//  SpotifyRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol SpotifyRequest {
    associatedtype ResponseType
    typealias Headers = [String: String]
    
    var routingPath: RoutingPath { get }
    var headers: Headers { get set }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

extension SpotifyRequest {
    var request: URLRequest {
        var request = URLRequest(routingPath: routingPath)
        request.allHTTPHeaderFields = headers
        request.addQuery(query: queryItems)
        request.httpMethod = method.rawValue
        return request
    }
    
    mutating func addNewAccessToken(token: String) {
        headers["Authorization"] = token        
    }
}
