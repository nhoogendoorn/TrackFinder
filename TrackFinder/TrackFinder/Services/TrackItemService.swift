//
//  TrackItemService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 21/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol TrackItemServiceProtocol {
    var apiManager: ApiProtocol { get set }
    func getTrackItem(id: String, completion: @escaping (Result<TrackItem, NetworkError>) -> Void)
    func getArtist(id: String, completion: @escaping (Result<CompleteArtist, NetworkError>) -> Void)
}

class TrackItemService: TrackItemServiceProtocol {
    var apiManager: ApiProtocol = ApiManager()
    
    func getTrackItem(id: String, completion: @escaping (Result<TrackItem, NetworkError>) -> Void) {
        let request = TrackItemRequest(id: id)
        apiManager.webApi.doRequest(request: request, loadCache: true) { result in
            if let response = try? result.getNetworkResult(TrackItem.self).get() {
                completion(.success(response))
            } else {
                completion(.failure(.fetchingError))
            }
        }
    }
    
    func getArtist(id: String, completion: @escaping (Result<CompleteArtist, NetworkError>) -> Void) {
        let request = CompleteArtistRequest(id: id)
        self.apiManager.webApi.doRequest(request: request, loadCache: true) { result in
            if let response = try? result.getNetworkResult(CompleteArtist.self).get() {
                completion(.success(response))
            } else {
                completion(.failure(.fetchingError))
            }
        }
    }
}
