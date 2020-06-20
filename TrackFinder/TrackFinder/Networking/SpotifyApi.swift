//
//  SpotifyApi.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class SpotifyApi: WebApiProtocol, DependencyResolver {
    var hasInternetConnection = true {
        didSet {
            setOperationQueueSuspsension()
        }
    }
    
    private var session: URLSession = URLSession.shared

    let operationQueue = ApiOperationQueue.shared

    var dataTask: URLSessionDataTask?
    
    func doRequest(request: SpotifyRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        // First check if the operation queue should be suspended, operations
        // can still be added, but will only resume when there is an active
        // internet connection and the access token is not expired.
        setOperationQueueSuspsension()
        
        if currentTokenIsExpired() {
            handleRefreshTokenOperation(completion: completion)
        }
        
        let operation = ApiRequestOperation(request: request, completion: completion)
        operationQueue.addOperation(operation)
    }
    
    func currentTokenIsExpired() -> Bool {
        guard
            let userPrefs = container?.resolve(UserPreferencesProtocol.self),
            let tokens = userPrefs.getTokens()
        else { return false }
        
        return tokens.isExpired

    }
    
    func setOperationQueueSuspsension() {
        self.operationQueue.isSuspended = suspendOperationQueue()
    }
    
    func suspendOperationQueue() -> Bool {
        // CHECK HERE IF there is active internet connction
        
        return !hasInternetConnection || currentTokenIsExpired()
    }
    
    private func handleRefreshTokenOperation(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        // MAIN THREAD?
        guard
            let userPrefs = container?.resolve(UserPreferencesProtocol.self),
            let tokens = userPrefs.getTokens()
        else { return }
        
        // We use a different operation queue here, because the api queue is supsended.
        let standardOperationQueue = OperationQueue.main
        let refreshRequest = RefreshTokenRequest(refreshToken: tokens.refreshToken)
        let operation = ApiRequestOperation(request: refreshRequest) { [weak self] result in
            guard let `self` = self else { return }
            if let response = try? result.get().getNetworkResult(RefreshTokenResponse.self).get() {
                DispatchQueue.main.async {
                    userPrefs.saveTokens(AuthTokens(accessToken: response.accessToken,
                                                    refreshToken: tokens.refreshToken,
                                                    expirationDate: Date.now(.second,
                                                                             offset: response.expiresIn)))
                    self.setOperationQueueSuspsension()
                }                                
            } else {
                completion(.failure(.fetchingError))
            }
        }
        standardOperationQueue.addOperation(operation)
    }
}
