//
//  RoutingPath.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum RoutingPath {
    case startAuthorization, getAccessToken, getRefreshToken, search
    case getTrack(id: String), getArtist(id: String)
    
    var path: String {
        switch self {
        case .getAccessToken: return "api/token"
        case .getRefreshToken: return "api/refresh_token"
        case .getTrack(let id): return "v1/tracks/\(id)"
        case .getArtist(let id): return "v1/artists/\(id)"
        case .search: return "v1/search"
        case .startAuthorization: return "authorize"
        }
    }
    
    var url: URL {
        switch self {
        case .getAccessToken, .getRefreshToken:
            return URL(string: Environment.baseAuthUrl + self.path)!
        case .startAuthorization:
            return URL(string: Environment.baseAccountUrl + self.path)!
        default:
            return URL(string: Environment.baseApiUrl + self.path)!
        }
    }
}
