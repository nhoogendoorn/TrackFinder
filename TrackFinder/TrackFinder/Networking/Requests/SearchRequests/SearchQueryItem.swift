//
//  SearchQueryItem.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum SearchQueryItem {
    static let minimumLimit = 1
    static let maximumLimit = 50
    static let defaultLimit = 20
    
    enum SearchContentType: String, Codable {
        case album, artist, playlist, track, show, episode
    }
    
    case query(query: String), contentType(type: SearchContentType), limit(_ limit: Int)
    
    enum CodingKeys: String, CodingKey {
        case query = "q"
        case contentType = "type"
        case limit
    }
    
    func create() -> URLQueryItem {
        switch self {
        case .contentType(let type):
            return URLQueryItem(name: CodingKeys.contentType.rawValue, value: type.rawValue)
        case .limit(let limit):
            return URLQueryItem(name: CodingKeys.limit.rawValue, value: getValidLimit(input: limit))
        case .query(let query):
            return URLQueryItem(name: CodingKeys.query.rawValue, value: query.encodeToURLQuery())
        }
    }
    
    func getValidLimit(input: Int) -> String {
        if isValidLimit(input: input) {
            return "\(input)"
        } else {
            return "\(Self.defaultLimit)"
        }
    }
    
    func isValidLimit(input: Int) -> Bool {
        Range(Self.minimumLimit...Self.maximumLimit) ~= input
    }
}
