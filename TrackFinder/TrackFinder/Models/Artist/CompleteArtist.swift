//
//  CompleteArtist.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 22/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - CompleteArtist
struct CompleteArtist: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers
    let genres: [String]
    let href: String
    let id: String
    let images: [CoverImage]
    let name: String
    let popularity: Int
    let type, uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers, genres, href, id, images, name, popularity, type, uri
    }
}

// MARK: CompleteArtist convenience initializers and mutators

extension CompleteArtist {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CompleteArtist.self, from: data)
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
        followers: Followers? = nil,
        genres: [String]? = nil,
        href: String? = nil,
        id: String? = nil,
        images: [CoverImage]? = nil,
        name: String? = nil,
        popularity: Int? = nil,
        type: String? = nil,
        uri: String? = nil
    ) -> CompleteArtist {
        return CompleteArtist(
            externalUrls: externalUrls ?? self.externalUrls,
            followers: followers ?? self.followers,
            genres: genres ?? self.genres,
            href: href ?? self.href,
            id: id ?? self.id,
            images: images ?? self.images,
            name: name ?? self.name,
            popularity: popularity ?? self.popularity,
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

extension CompleteArtist {
    static func getMock() -> Self {
        Self(externalUrls: ExternalUrls(spotify: ""),
             followers: Followers(href: nil, total: 1), genres: [], href: "",
             id: "", images: [], name: "", popularity: 1, type: "", uri: "")
    }
}
