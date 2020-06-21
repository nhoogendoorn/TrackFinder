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
    case search = "v1/search"
    
    var url: URL {
        switch self {
        case .getToken, .startAuthorization:
            return URL(string: Environment.baseAccountUrl + self.rawValue)!
        default:
            return URL(string: Environment.baseApiUrl + self.rawValue)!
        }
    }
}
