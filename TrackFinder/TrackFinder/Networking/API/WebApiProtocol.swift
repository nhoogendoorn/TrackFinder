//
//  WebApiProtocol.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol WebApiProtocol {
    func doRequest(request: SpotifyRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)    
}
