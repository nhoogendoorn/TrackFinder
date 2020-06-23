//
//  Environment.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum Environment {
    static let spotifyClientId: String = "ad5a0ea0dbd042c080662e6cf9444b5a"
    static let spotifySecretId: String = "e1b079d5f1ee450094926dcda77800c7"
    static var spotifyAuthorizationId: String {
        let combinedString = "\(spotifyClientId):\(spotifySecretId)"
        guard let data = combinedString.data(using: String.Encoding.utf8) else { return "" }
        return data.base64EncodedString()
    }
    static let spotifyRedirectUri: String = "trackfinder://spotify-login-callback"
    static let baseApiUrl: String = "https://api.spotify.com/"
    static let baseAccountUrl: String = "https://accounts.spotify.com/"
}
