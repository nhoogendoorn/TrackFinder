//
//  AuthenticationService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol AuthenticationServiceProtocol {
    func startSpotifyAuthorization()
    func getAccessToken(code: String?, completion: @escaping (Result<AuthTokenResponse, NetworkError>) -> Void)
    func requestNewToken(completion: @escaping (Result<RefreshTokenResponse, NetworkError>) -> Void)
}

class AuthenticationService: AuthenticationServiceProtocol, DependencyResolver {
    
    let apiManager = ApiManager()
    
    lazy var userPrefs: UserPreferencesProtocol? = {
        container?.resolve(UserPreferencesProtocol.self)
    }()
    
    func startSpotifyAuthorization() {
        let request = AuthorizationRequest()
        guard let url = request.getCompleteUrl() else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func getAccessToken(code: String?, completion: @escaping (Result<AuthTokenResponse, NetworkError>) -> Void) {
        guard let code = code else { completion(.failure(.postingError)); return }
        let request = AccessTokenRequest(code: code)
        apiManager.webApi.doRequest(request: request) { result in
            if let response = try? result.getNetworkResult(AuthTokenResponse.self).get() {
                DispatchQueue.main.async {
                    self.userPrefs?.saveTokens(response.authTokens)
                    completion(.success(response))
                }
            } else {
                completion(.failure(.fetchingError))
            }
        }
    }
    
    func requestNewToken(completion: @escaping (Result<RefreshTokenResponse, NetworkError>) -> Void) {
        guard let tokens = getAuthenticationTokens() else {
            completion(.failure(.fetchingError))
            return
        }
            
        let request = RefreshTokenRequest(refreshToken: tokens.refreshToken)
        apiManager.webApi.doRequest(request: request) { result in
            if let data = try? result.getNetworkResult(RefreshTokenResponse.self) {
                completion(data)
            } else {
                completion(.failure(.fetchingError))
            }
        }
    }
}
