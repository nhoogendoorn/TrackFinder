//
//  AuthenticationService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol AuthenticationServiceProtocol {
    var apiManager: ApiProtocol { get set }
    func startSpotifyAuthorization()
    func getAccessToken(code: String?, completion: @escaping (Result<AuthTokenResponse, NetworkError>) -> Void)
}

class AuthenticationService: AuthenticationServiceProtocol, DependencyResolver {
    
    var apiManager: ApiProtocol = ApiManager()
    
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
        apiManager.webApi.doRequest(request: request, loadCache: false) { [weak self] result in
            guard let `self` = self else { return }
            if let response = try? result.getNetworkResult(AuthTokenResponse.self).get() {
                DispatchQueue.main.async {
                    self.userPrefs?.saveTokens(response.authTokens)
                    ApiOperationQueue.shared.applyNewToken(tokens: response.authTokens)
                    completion(.success(response))
                }
            } else {
                completion(.failure(.fetchingError))
            }
        }
    }
}
