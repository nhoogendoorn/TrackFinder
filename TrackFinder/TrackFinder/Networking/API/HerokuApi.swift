//
//  HerokuApi.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 01/07/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class HerokuApi: WebApiProtocol {
    func doRequest(request: SpotifyRequest, loadCache: Bool, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request.generateRequest()) { (data, _, _) in
            data?.logDataResponse(prefix: "Data")
            if let foundData = data {
                completion(.success(foundData))
            } else {
                completion(.failure(.fetchingError))
            }
        }.resume()
    }
}
