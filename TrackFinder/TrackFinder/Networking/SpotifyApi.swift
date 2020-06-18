//
//  SpotifyApi.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case fetchingError, postingError, decodingError
}


class SpotifyApi: WebApiProtocol {
    
    private var session: URLSession = URLSession.shared
    
    let operationQueue = OperationQueue()
    
    var dataTask: URLSessionDataTask?
    
    func doRequest(router: BaseRouter, with newToken: String? = nil, completion: @escaping (Swift.Result<Data, NetworkError>) -> Void) {
        let authenticatedRouter = router.addAuthentication(withNewToken: newToken)
        let request: URLRequest = URLRequest(router: authenticatedRouter)
        session.dataTask(request: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
                        
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.fetchingError))
            }
        }.resume()

    }
}
