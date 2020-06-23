//
//  SearchTrackResponse.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - SearchTrackResponse
struct SearchTrackResponse: Codable {
    let tracks: Tracks
}

// MARK: SearchTrackResponse convenience initializers and mutators

extension SearchTrackResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SearchTrackResponse.self, from: data)
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
        tracks: Tracks? = nil
    ) -> SearchTrackResponse {
        return SearchTrackResponse(
            tracks: tracks ?? self.tracks
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension SearchTrackResponse {
    static func getMock(items: [TrackItem]) -> Self {
        let tracks = Tracks(href: .empty, items: items, limit: 1, next: nil,
                            offset: 1, previous: nil, total: 1)
        return Self(tracks: tracks)
    }
}
