//
//  Data+Extension.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension Data {
    func logDataResponse(prefix: String = "") {
        if let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) {
            log.info("\(prefix): \(String(data: data, encoding: .utf8) ?? "empty json")")
        } else if let stringResponse = String(data: self, encoding: .utf8) {
            log.info(stringResponse)
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

    func decodeNetworkResult<T: Decodable>(_ type: T.Type) -> Result<T, NetworkError> {
        if let correctData = self.toObject(T.self) {
            return .success(correctData)
        } else if self.toObject(ErrorResponse.self) != nil || self.toObject(SearchError.self) != nil {
            log.error("Failed to fetch data")
            return .failure(.fetchingError)
        } else {
            log.error("Failed to decode data")
            return .failure(.decodingError)
        }
    }
}

extension Result where Success == Data, Failure == NetworkError {
    func getNetworkResult<T: Decodable>(_ type: T.Type) throws -> Result<T, NetworkError> {
        try self.get().decodeNetworkResult(T.self)
    }
}
