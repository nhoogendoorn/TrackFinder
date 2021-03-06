//
//  SpotifyApi.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class SpotifyApi: WebApiProtocol, DependencyResolver {
    
    private var session: URLSession = URLSession.shared
    
    let operationQueue: OperationQueue & ApiOperationQueueProtocol = ApiOperationQueue.shared
    
    var dataTask: URLSessionDataTask?
    
    func doRequest(request: SpotifyRequest, loadCache: Bool, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        // First check if the operation queue should be suspended, operations
        // can still be added, but will only resume when there is an active
        // internet connection and the access token is not expired.
        operationQueue.setSuspensionState()
        
        if operationQueue.currentTokenIsExpired {
            // If the current token is expired, refresh the token. Do this on a
            // different queue than the api operation queue, so it can operate independent.
            handleRefreshTokenOperation(completion: completion)
        }
        
        let operation = ApiRequestOperation(request: request, loadCache: loadCache, completion: completion)
        operationQueue.addApiOperation(operation)
        
    }
    
    private func handleRefreshTokenOperation(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard
            let userPrefs = container?.resolve(UserPreferencesProtocol.self),
            let tokens = getAuthenticationTokens()
            else { return }
        
        let authService = container?.resolve(AuthenticationServiceProtocol.self)
        authService?.getRefreshedToken(refreshToken: tokens.refreshToken) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let newAuthTokens = AuthTokens(accessToken: response.accessToken,
                                                   refreshToken: tokens.refreshToken,
                                                   expirationDate: Date.now(.second, offset: response.expiresIn))
                    userPrefs.saveTokens(newAuthTokens)
                    self.operationQueue.applyNewToken(tokens: newAuthTokens)
                    self.operationQueue.setSuspensionState()
                }
            case .failure:
                completion(.failure(.fetchingError))
            }
            
        }
    }
}
