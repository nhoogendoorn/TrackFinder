//
//  RoutingPath.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum RoutingPath: String {
    case startAuthorization = "authorize"
    case getToken = "api/token"
    
    static func url(for path: RoutingPath) -> URL {
        URL(string: Environment.baseUrl + path.rawValue)!
    }
}
