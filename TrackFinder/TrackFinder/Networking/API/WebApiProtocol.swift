//
//  WebApiProtocol.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol WebApiProtocol: class {
    func doRequest(request: SpotifyRequest, loadCache: Bool, completion: @escaping (Result<Data, NetworkError>) -> Void)    
}
