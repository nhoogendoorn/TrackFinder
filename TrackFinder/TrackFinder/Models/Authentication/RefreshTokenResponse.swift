//
//  RefreshTokenResponse.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - RefreshTokenResponse
struct RefreshTokenResponse: Codable {
    let accessToken, tokenType, scope: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case expiresIn = "expires_in"
    }
}

// MARK: RefreshTokenResponse convenience initializers and mutators

extension RefreshTokenResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(RefreshTokenResponse.self, from: data)
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
        accessToken: String? = nil,
        tokenType: String? = nil,
        scope: String? = nil,
        expiresIn: Int? = nil
    ) -> RefreshTokenResponse {
        return RefreshTokenResponse(
            accessToken: accessToken ?? self.accessToken,
            tokenType: tokenType ?? self.tokenType,
            scope: scope ?? self.scope,
            expiresIn: expiresIn ?? self.expiresIn
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
