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
    private static let urlEncoding = "application/x-www-form-urlencoded"
    
    private enum CodingKeys: String, CodingKey {
        case authorization = "Authorization"
        case contentType = "Content-Type"
    }
    
    private enum SpotifyAuthorizationType: DependencyResolver {
        case basic, bearer(newToken: String?)
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
            case .bearer(let newToken):
                if let newToken = newToken {
                    return "Bearer \(newToken)"
                } else {
                    let accessToken = type.getAuthenticationTokens()?.accessToken ?? .empty
                    return "Bearer \(accessToken)"
                }
            }
        case .contentType:
            return Self.urlEncoding
        }
    }
    
    static func generateBasicHeader() -> Headers {
        [
            CodingKeys.authorization.rawValue: Self.generateValueForHeader(.authorization(type: .basic)),
            CodingKeys.contentType.rawValue: Self.generateValueForHeader(.contentType)
        ]
    }
    
    static func generateBearerHeader(with newToken: String? = nil) -> Headers {
        [
            CodingKeys.authorization.rawValue: Self.generateValueForHeader(.authorization(type: .bearer(newToken: newToken))),
            CodingKeys.contentType.rawValue: Self.generateValueForHeader(.contentType)
        ]
    }
}
