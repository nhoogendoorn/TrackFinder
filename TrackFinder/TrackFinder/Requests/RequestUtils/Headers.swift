//
//  Headers.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

typealias Headers = [String: String]
extension Headers {
    private static let standardContentType = "application/x-www-form-urlencoded"
    
    private enum CodingKeys: String, CodingKey {
        case authorization = "Authorization"
        case contentType = "Content-Type"
    }
    
    private enum SpotifyAuthorizationType {
        case basic, bearer(token: String)
    }
    
    private enum SpotifyHeader {
        case authorization(type: SpotifyAuthorizationType), contentType
    }
    
    private static func generateValueForHeader(_ type: SpotifyHeader) -> String {
        switch type {
        case .authorization(type: let type):
            switch type {
            case .basic:
                return "Basic \(Environment.spotifyAuthorizationId)"
            case .bearer(token: let token):
                return "Bearer \(token)"
            }
        case .contentType:
            return Self.standardContentType
        }
    }
    
    static func generateBasicHeader() -> Headers {
        [
            CodingKeys.authorization.rawValue: Self.generateValueForHeader(.authorization(type: .basic)),
            CodingKeys.contentType.rawValue: Self.generateValueForHeader(.contentType)
        ]
    }
    
    static func generateBearerHeader(token: String) -> Headers {
        [
            CodingKeys.authorization.rawValue: Self.generateValueForHeader(.authorization(type: .bearer(token: token))),
            CodingKeys.contentType.rawValue: Self.generateValueForHeader(.contentType)
        ]
    }
}
