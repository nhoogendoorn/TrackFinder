//
//  MockServiceProtocol.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
@testable import TrackFinder

protocol MockServiceProtocol: class {
    var data: Codable? { get set }
    var error: NetworkError? { get set }
}

extension MockServiceProtocol {
    func injectData(data: Codable?, error: NetworkError?) {
        self.data = data
        self.error = error
    }
    
    func handleCompletion<T: Codable>(data: Codable?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if let response = data as? T {
            completion(.success(response))
        } else if let error = error {
            completion(.failure(error))
        } else {
            completion(.failure(.decodingError))
        }
    }
}
