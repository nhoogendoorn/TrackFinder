//
//  BasicAuthorizationHeader.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension Dictionary where Key == String, Value == String {
    static let basicAuthorizationHeader = [
        "Authorization": "Basic \(Environment.spotifyAuthorizationId)",
        "Content-Type": "application/x-www-form-urlencoded"
    ]
}
