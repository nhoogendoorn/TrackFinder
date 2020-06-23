//
//  Tracks.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

// MARK: - Tracks
struct Tracks: Codable {
    let href: String
    let items: [TrackItem]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

// MARK: Tracks convenience initializers and mutators

extension Tracks {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Tracks.self, from: data)
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
        href: String? = nil,
        items: [TrackItem]? = nil,
        limit: Int? = nil,
        next: String? = nil,
        offset: Int? = nil,
        previous: String? = nil,
        total: Int? = nil
    ) -> Tracks {
        return Tracks(
            href: href ?? self.href,
            items: items ?? self.items,
            limit: limit ?? self.limit,
            next: next ?? self.next,
            offset: offset ?? self.offset,
            previous: previous ?? self.previous,
            total: total ?? self.total
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
