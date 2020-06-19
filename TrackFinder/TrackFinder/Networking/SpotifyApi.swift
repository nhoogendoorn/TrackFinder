//
//  SpotifyApi.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class SpotifyApi: WebApiProtocol, DependencyResolver {
    var shouldRefreshToken = true
    
    
    private var session: URLSession = URLSession.shared

    let operationQueue = ApiOperationQueue.shared

    var dataTask: URLSessionDataTask?
    
    func doRequest<T: SpotifyRequest>(request: T, with newToken: String?, completion: @escaping (Result<T.ResponseType, NetworkError>) -> Void) {
                
        if shouldRefreshToken {
            operationQueue.isSuspended = true
            // MAIN THREAD?
            guard
                let userPrefs = container?.resolve(UserPreferencesProtocol.self),
                let tokens = userPrefs.getTokens()
            else { return }
            
            let request = RefreshTokenRequest(refreshToken: tokens.refreshToken)
            session.dataTask(with: request.request) { [weak self] (data, _, _) in
                guard let result = data?.getNetworkResult(RefreshTokenResponse.self) else { completion(.failure(.fetchingError)); return }
                switch result {
                case .failure:
                    completion(.failure(.fetchingError))
                case .success(let newToken):
                    DispatchQueue.main.async {
                        userPrefs.saveTokens(AuthTokens(accessToken: newToken.accessToken, refreshToken: tokens.refreshToken))
                    }
                    self?.shouldRefreshToken = false
                    self?.operationQueue.isSuspended = false
                }
            }
        }
    }


}

class ApiRequestOperation<T: SpotifyRequest>: Operation {
    var request: T
    
    init(request: T) {
        self.request = request
        super.init()
        
    }
    
    func addNewAccessToken(token: String) {
        request.addNewAccessToken(token: token)
    }
}

class ApiOperationQueue: OperationQueue {
    static let shared = ApiOperationQueue()
    
    func applyNewToken<T: SpotifyRequest>(token: String?, requestType: T) {
        let requestOperations = self.operations as? [ApiRequestOperation<T>]
        requestOperations?.forEach {
            guard let newToken = token else { return }
            $0.request.addNewAccessToken(token: newToken)
        }
    }
}
