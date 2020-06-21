//
//  URLRequest+Extension.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension URLRequest {
    init(routingPath: RoutingPath) {
        let url = routingPath.url
        self.init(url: url)
    }
    
    mutating func addQuery(query: [URLQueryItem]) {
        guard let url = self.url else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = query
        let body = urlComponents?.query?.data(using: .utf8)
        switch self.httpMethod {
        case HTTPMethod.post.rawValue:
            self.httpBody = body
        case HTTPMethod.get.rawValue:
            self.url = urlComponents?.url
        default:
            break
        }
    }
}
