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
        let url = RoutingPath.url(for: routingPath)
        self.init(url: url)
    }
    
    mutating func addQuery(query: [URLQueryItem]) {
        var urlComponents = URLComponents()
        urlComponents.queryItems = query
        let body = urlComponents.query?.data(using: .utf8)
        self.httpBody = body
    }
}
