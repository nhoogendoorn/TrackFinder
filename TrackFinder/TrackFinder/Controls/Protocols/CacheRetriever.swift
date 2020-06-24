//
//  CacheRetriever.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 24/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol CacheRetriever { }

extension CacheRetriever {
    func getCachedResponse(request: SpotifyRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let cachedResponseData = URLCache.shared.cachedResponse(for: request.generateRequest())?.data
        guard let decodeResult = cachedResponseData else { return }        
        completion(.success(decodeResult))
        
    }
}
