//
//  TrackArtist.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - Artist
struct TrackArtist: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id, name: String
    let type: SearchQueryItem.SearchContentType
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// MARK: Artist convenience initializers and mutators

extension TrackArtist {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrackArtist.self, from: data)
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
        externalUrls: ExternalUrls? = nil,
        href: String? = nil,
        id: String? = nil,
        name: String? = nil,
        type: SearchQueryItem.SearchContentType? = nil,
        uri: String? = nil
    ) -> TrackArtist {
        return TrackArtist(
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            name: name ?? self.name,
            type: type ?? self.type,
            uri: uri ?? self.uri
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
