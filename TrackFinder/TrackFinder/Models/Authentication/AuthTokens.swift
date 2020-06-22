//
//  AuthTokens.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct AuthTokens {
    let accessToken, refreshToken: String
    let expirationDate: Date
    
    var isExpired: Bool {
        Date.now(.minute, offset: 10) >= expirationDate
    }
}
