//
//  UserPreferences.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol UserPreferencesProtocol {
    func saveTokens(_ authTokens: AuthTokens)
    func getTokens() -> AuthTokens?
    func deleteTokens()
}

class UserPreferences: UserPreferencesProtocol {
    private let userDefaults = UserDefaults.standard
    
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
    }
    
    func saveTokens(_ authTokens: AuthTokens) {
        userDefaults.set(authTokens.accessToken, forKey: CodingKeys.accessToken.rawValue)
        userDefaults.set(authTokens.refreshToken, forKey: CodingKeys.refreshToken.rawValue)
    }
    
    func getTokens() -> AuthTokens? {
        guard
            let accessToken = userDefaults.string(forKey: CodingKeys.accessToken.rawValue),
            let refreshToken = userDefaults.string(forKey: CodingKeys.refreshToken.rawValue)
        else { return nil }
        
        return AuthTokens(accessToken: accessToken, refreshToken: refreshToken)
    }
    
    func deleteTokens() {
        userDefaults.removeObject(forKey: CodingKeys.accessToken.rawValue)
        userDefaults.removeObject(forKey: CodingKeys.refreshToken.rawValue)
    }
}
