//
//  RoutingPath.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum RoutingPath {
    case startAuthorization, getToken, search, getTrack(id: String)
    
    var path: String {
        switch self {
        case .getToken: return "api/token"
        case .getTrack(let id): return "v1/tracks/\(id)"
        case .search: return "v1/search"
        case .startAuthorization: return "authorize"
        }
    }
    
    var url: URL {
        switch self {
        case .getToken, .startAuthorization:
            return URL(string: Environment.baseAccountUrl + self.path)!
        default:
            return URL(string: Environment.baseApiUrl + self.path)!
        }
    }
}
