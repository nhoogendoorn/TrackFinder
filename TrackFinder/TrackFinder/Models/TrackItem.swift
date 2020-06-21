//
//  TrackItem.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
// MARK: - Item
struct TrackItem: Codable {
    let album: Album
    let artists: [Artist]
    let discNumber, durationMS: Int
    let explicit: Bool
    let href: String
    let id: String
    let isLocal, isPlayable: Bool
    let name: String
    let popularity: Int
    let previewURL: String
    let trackNumber: Int
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case album, artists
        case discNumber = "disc_number"
        case durationMS = "duration_ms"
        case explicit
        case href, id
        case isLocal = "is_local"
        case isPlayable = "is_playable"
        case name, popularity
        case previewURL = "preview_url"
        case trackNumber = "track_number"
        case type, uri
    }
}

// MARK: Item convenience initializers and mutators

extension TrackItem {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TrackItem.self, from: data)
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
        album: Album? = nil,
        artists: [Artist]? = nil,
        discNumber: Int? = nil,
        durationMS: Int? = nil,
        explicit: Bool? = nil,
        href: String? = nil,
        id: String? = nil,
        isLocal: Bool? = nil,
        isPlayable: Bool? = nil,
        name: String? = nil,
        popularity: Int? = nil,
        previewURL: String? = nil,
        trackNumber: Int? = nil,
        type: String? = nil,
        uri: String? = nil
    ) -> TrackItem {
        return TrackItem(
            album: album ?? self.album,
            artists: artists ?? self.artists,
            discNumber: discNumber ?? self.discNumber,
            durationMS: durationMS ?? self.durationMS,
            explicit: explicit ?? self.explicit,
            href: href ?? self.href,
            id: id ?? self.id,
            isLocal: isLocal ?? self.isLocal,
            isPlayable: isPlayable ?? self.isPlayable,
            name: name ?? self.name,
            popularity: popularity ?? self.popularity,
            previewURL: previewURL ?? self.previewURL,
            trackNumber: trackNumber ?? self.trackNumber,
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
