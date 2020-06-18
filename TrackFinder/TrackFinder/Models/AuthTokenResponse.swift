//
//  AuthTokenResponse.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 17/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - AuthTokenResponse
struct AuthTokenResponse: Codable {
    let accessToken, tokenType, scope: String
    let expiresIn: Int
    let refreshToken: String
    let authTokens: AuthTokens
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}

// MARK: AuthTokenResponse convenience initializers and mutators

extension AuthTokenResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let accessTokenResponse = try container.decode(String.self, forKey: .accessToken)
        accessToken = accessTokenResponse
        
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scope = try container.decode(String.self, forKey: .scope)
        expiresIn = try container.decode(Int.self, forKey: .expiresIn)
        
        let refreshTokenResponse = try container.decode(String.self, forKey: .refreshToken)
        self.refreshToken = refreshTokenResponse
        
        authTokens = AuthTokens(accessToken: accessTokenResponse,
                                refreshToken: refreshTokenResponse)        
    }

    init(data: Data) throws {
        self = try newJSONDecoder().decode(AuthTokenResponse.self, from: data)
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
        expiresIn: Int? = nil,
        refreshToken: String? = nil
    ) -> AuthTokenResponse {
        return AuthTokenResponse(
            accessToken: accessToken ?? self.accessToken,
            tokenType: tokenType ?? self.tokenType,
            scope: scope ?? self.scope,
            expiresIn: expiresIn ?? self.expiresIn,
            refreshToken: refreshToken ?? self.refreshToken,
            authTokens: AuthTokens(accessToken: accessToken ?? self.accessToken,
                                   refreshToken: refreshToken ?? self.refreshToken)
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
