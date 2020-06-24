//
//  MockApi.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
@testable import TrackFinder

class MockApi<Response: Codable>: WebApiProtocol {    
    var data: Response?
    var error: NetworkError?
    
    func inject(data: Response?, error: NetworkError?) {
        self.data = data
        self.error = error
    }
    
    func doRequest(request: SpotifyRequest, loadCache: Bool, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let data = data, let encodedData = try? newJSONEncoder().encode(data) {
            completion(.success(encodedData))
        } else {
            completion(.failure(.fetchingError))
        }
    }
}
