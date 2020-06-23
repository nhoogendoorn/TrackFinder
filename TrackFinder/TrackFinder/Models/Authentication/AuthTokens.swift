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

extension AuthTokens {
    static func getMock(expired: Bool) -> Self {
        let yesterday = Date.now(.day, offset: -1)
        let tomorrow = Date.now(.day, offset: 1)
        
        return Self(accessToken: "1",
                    refreshToken: "2",
                    expirationDate: expired ? yesterday : tomorrow)
    }
}
