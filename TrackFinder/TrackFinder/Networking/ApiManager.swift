//
//  ApiManager.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct ApiManager: ApiProtocol, DependencyResolver {
    var webApi: WebApiProtocol = SpotifyApi()
    
    func doRequest(request: SpotifyRequest, addAccessToken: Bool, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        var changeableRequest = request
        if addAccessToken, let authTokens = getAuthenticationTokens() {
            changeableRequest.setAccessToken(token: authTokens.accessToken)
        }
        webApi.doRequest(request: changeableRequest, completion: completion)
    }
}
