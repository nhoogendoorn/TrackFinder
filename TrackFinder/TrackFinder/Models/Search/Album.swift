//
//  Album.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - Album
struct Album: Codable {
    let albumType: String
    let artists: [TrackArtist]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [CoverImage]
    let name, releaseDate, releaseDatePrecision: String
    let totalTracks: Int
    let type, uri: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case totalTracks = "total_tracks"
        case type, uri
    }
}

// MARK: Album convenience initializers and mutators

extension Album {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Album.self, from: data)
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
        albumType: String? = nil,
        artists: [TrackArtist]? = nil,
        externalUrls: ExternalUrls? = nil,
        href: String? = nil,
        id: String? = nil,
        images: [CoverImage]? = nil,
        name: String? = nil,
        releaseDate: String? = nil,
        releaseDatePrecision: String? = nil,
        totalTracks: Int? = nil,
        type: String? = nil,
        uri: String? = nil
    ) -> Album {
        return Album(
            albumType: albumType ?? self.albumType,
            artists: artists ?? self.artists,
            externalUrls: externalUrls ?? self.externalUrls,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            releaseDate: releaseDate ?? self.releaseDate,
            releaseDatePrecision: releaseDatePrecision ?? self.releaseDatePrecision,
            totalTracks: totalTracks ?? self.totalTracks,
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

extension Album {
    static func getMock() -> Self {
        Self(albumType: "1", artists: [], externalUrls: ExternalUrls(spotify: ""),
             href: "", id: "", images: [], name: "", releaseDate: "",
             releaseDatePrecision: "", totalTracks: 1, type: "", uri: "")
    }
}
