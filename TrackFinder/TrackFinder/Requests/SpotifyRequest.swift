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
        var request = getUrlRequest(with: customUrl)
        request.allHTTPHeaderFields = headers
        request.addQuery(query: queryItems)
        request.httpMethod = method.rawValue
        return request
    }
    
    private func getUrlRequest(with customURL: String?) -> URLRequest {
        if let customUrl = customURL, let url = URL(string: customUrl) {
            return URLRequest(url: url)
        } else {
            return URLRequest(routingPath: routingPath)
        }
    }
    
    mutating func setAccessToken(token: String) {
        headers = .generateBearerHeader(with: token)
    }
}
