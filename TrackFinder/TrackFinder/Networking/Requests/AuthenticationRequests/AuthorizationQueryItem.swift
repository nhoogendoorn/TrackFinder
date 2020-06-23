//
//  AuthorizationQueryItem.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum AuthorizationQueryItem {
    case authCode(code: String), redirectUri, grantType(type: SpotifyGrantType)
    case refreshToken(token: String), responseType(type: String), scope(scope: String)
    case state(state: String), clientId
    
    enum CodingKeys: String, CodingKey {
        case authCode = "code"
        case redirectUri = "redirect_uri"
        case grantType = "grant_type"
        case responseType = "response_type"
        case refreshToken = "refresh_token"
        case clientId = "client_id"
        case scope, state
    }
    
    enum SpotifyGrantType: String {
        case refreshToken = "refresh_token"
        case authorization = "authorization_code"
    }
    
    func create() -> URLQueryItem {
        switch self {
        case .authCode(code: let code):
            return URLQueryItem(name: CodingKeys.authCode.rawValue, value: code)
        case .clientId:
            return URLQueryItem(name: CodingKeys.clientId.rawValue, value: Environment.spotifyClientId)
        case .grantType(type: let type):
            return URLQueryItem(name: CodingKeys.grantType.rawValue, value: type.rawValue)
        case .redirectUri:
            return URLQueryItem(name: CodingKeys.redirectUri.rawValue, value: Environment.spotifyRedirectUri)
        case .refreshToken(let token):
            return URLQueryItem(name: CodingKeys.refreshToken.rawValue, value: token)
        case .responseType(let type):
            return URLQueryItem(name: CodingKeys.responseType.rawValue, value: type)
        case .scope(let scope):
            return URLQueryItem(name: CodingKeys.scope.rawValue, value: scope)
        case .state(let state):
            return URLQueryItem(name: CodingKeys.state.rawValue, value: state)
        }
    }
}
