//
//  ApiProtocol.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol ApiProtocol {
    var webApi: WebApiProtocol { get }
    func doRequest(request: SpotifyRequest, addAccessToken: Bool, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
