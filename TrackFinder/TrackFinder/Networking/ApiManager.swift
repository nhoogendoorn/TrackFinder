//
//  ApiManager.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct ApiManager: ApiProtocol {
    let webApi: WebApiProtocol = SpotifyApi()
//    func authenticate(router: BaseRouter, completion: @escaping (Result<Data, NetworkError>) -> Void) {
//        webApi.doRequest(router: router, with: nil, completion: completion)
//    }
}
