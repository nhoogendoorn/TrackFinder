//
//  ExternalUrl.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 21/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - ExternalUrls
struct ExternalUrls: Codable {
    let spotify: String
}

// MARK: ExternalUrls convenience initializers and mutators

extension ExternalUrls {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(ExternalUrls.self, from: data)
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
        spotify: String? = nil
    ) -> ExternalUrls {
        return ExternalUrls(
            spotify: spotify ?? self.spotify
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
