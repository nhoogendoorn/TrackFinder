//
//  SearchService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol {
    var apiManager: ApiProtocol { get set }
    func searchTrack(query: String, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void)
    func loadNextPage(nextPageUrl: String?, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void)
}

class SearchService: SearchServiceProtocol {
    var apiManager: ApiProtocol = ApiManager()
    
    fileprivate func handleSearchTrackResponse(_ result: Result<Data, NetworkError>, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void) {
        if let response = try? result.getNetworkResult(SearchTrackResponse.self).get() {
            if response.tracks.items.isEmpty {
                completion(.failure(.noResults))
            } else {
                completion(.success(response))
            }            
        } else if let searchError = try? result.getNetworkResult(SearchErrorResponse.self).get() {
            log.error(searchError.error.message)
            completion(.failure(.noResults))
        } else {
            completion(.failure(.fetchingError))
        }        
    }
    
    func searchTrack(query: String, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void) {
        let request = SearchTrackRequest(query: query, type: .track)
        apiManager.webApi.doRequest(request: request) { [weak self] result in
            guard let `self` = self else { return }
            self.handleSearchTrackResponse(result, completion: completion)
        }
    }
    
    func loadNextPage(nextPageUrl: String?, completion: @escaping (Result<SearchTrackResponse, NetworkError>) -> Void) {
        // Spotify gives a custom url for loading the next page. So the query can be
        // empty here as the given url contains the original query.
        let request = SearchTrackRequest(query: .empty, nextPage: nextPageUrl, type: .track)
        apiManager.webApi.doRequest(request: request) { [weak self] result in
            guard let `self` = self else { return }
            self.handleSearchTrackResponse(result, completion: completion)
        }
        
    }
}
