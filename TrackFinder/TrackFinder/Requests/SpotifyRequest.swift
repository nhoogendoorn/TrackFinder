//
//  SpotifyRequest.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol SpotifyRequest {    
    var routingPath: RoutingPath { get }
    var headers: Headers { get set }
    var queryItems: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var customUrl: String? { get }
}

extension SpotifyRequest {
    func generateRequest() -> URLRequest {
        if let customRequest = generateCustomRequest() {
            return customRequest
        } else {
            return generateSpotifyRequest()
        }
    }
    
    fileprivate func generateSpotifyRequest() -> URLRequest {
        var request = URLRequest(routingPath: routingPath)
        request.allHTTPHeaderFields = headers
        request.addQuery(query: queryItems)
        request.httpMethod = method.rawValue
        return request
    }
    
    fileprivate func generateCustomRequest() -> URLRequest? {
        guard let customUrl = customUrl, let url = URL(string: customUrl) else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        return request
    }
    
    mutating func setAccessToken(token: String) {
        headers = .generateBearerHeader(with: token)
    }
}
