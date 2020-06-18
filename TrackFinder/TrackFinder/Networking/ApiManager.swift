//
//  ApiManager.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation


struct ApiManager: ApiProtocol {    
    let webApi: WebApiProtocol = SpotifyApi()
    
    func authenticate(router: BaseRouter, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        webApi.doRequest(router: router, with: nil, completion: completion)
    }
}

extension Data {
    func logJson(prefix: String = "") {
        if let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
            log.info("\(prefix): \(String(data: data, encoding: .utf8) ?? "empty json")")
        } else {
            log.error("Failed to decode as Json")
        }
    }
    
    private func toObject<T: Decodable>(_ type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: self)
            return object
        } catch {
            return nil
        }
    }
        
    func getNetworkResult<T: Decodable>(_ type: T.Type) -> Result<T, NetworkError> {
        if let correctData = self.toObject(T.self) {
            return .success(correctData)
        } else if let _ = self.toObject(ErrorResponse.self) {
            return .failure(.fetchingError)
        } else {
            return .failure(.decodingError)
        }
    }
}
