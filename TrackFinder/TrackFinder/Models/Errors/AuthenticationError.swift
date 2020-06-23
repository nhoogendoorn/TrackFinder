//
//  AuthenticationError.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - ErrorResponse
struct AuthenticationError: Codable {
    let error: String?
}

// MARK: AuthenticationError convenience initializers and mutators

extension AuthenticationError {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuthenticationError.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        error: String? = nil
    ) -> AuthenticationError {
        return AuthenticationError(
            error: error ?? self.error
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
