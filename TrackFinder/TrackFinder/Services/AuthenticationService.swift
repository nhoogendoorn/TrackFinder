//
//  AuthenticationService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class AuthenticationService: DependencyResolver {
    
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
        let request = AccessTokenRequest(code: code).generateRequest()
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completion(.failure(.postingError))
                return
            }

            let result = data.getNetworkResult(AuthTokenResponse.self)
            
            switch result {
            case .failure:
                completion(.failure(.fetchingError))
            case .success(let authTokenResponse):
                DispatchQueue.main.async {
                    self.userPrefs?.saveTokens(authTokenResponse.authTokens)
                }
                completion(.success(authTokenResponse))
            }
        }.resume()
    }
    
    func requestNewToken(completion: @escaping (Result<RefreshTokenResponse, NetworkError>) -> Void) {
        
        guard
            let refreshToken = userPrefs?.getTokens()?.refreshToken
        else {
            completion(.failure(.fetchingError))
            return
        }
            
        let request = RefreshTokenRequest(refreshToken: refreshToken).generateRequest()
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completion(.failure(.postingError))
                return
            }
            let result = data.getNetworkResult(RefreshTokenResponse.self)
            
            switch result {
            case .failure:
                completion(.failure(.fetchingError))
            case .success(let refreshTokenResponse):
                let tokens = AuthTokens(accessToken: refreshTokenResponse.accessToken,
                                        refreshToken: refreshToken,
                                        expirationDate: Date.now(.second, offset: refreshTokenResponse.expiresIn))
                DispatchQueue.main.async {
                    self.userPrefs?.saveTokens(tokens)
                }
                completion(.success(refreshTokenResponse))
            }
        }.resume()
    }
}
