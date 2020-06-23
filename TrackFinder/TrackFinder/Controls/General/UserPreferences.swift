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
        case accessToken, refreshToken, expirationDate
    }

    func saveTokens(_ authTokens: AuthTokens) {
        userDefaults.set(authTokens.accessToken, forKey: CodingKeys.accessToken.rawValue)
        userDefaults.set(authTokens.refreshToken, forKey: CodingKeys.refreshToken.rawValue)
        userDefaults.set(authTokens.expirationDate.toString(), forKey: CodingKeys.expirationDate.rawValue)
    }

    func getTokens() -> AuthTokens? {
        guard
            let accessToken = userDefaults.string(forKey: CodingKeys.accessToken.rawValue),
            let refreshToken = userDefaults.string(forKey: CodingKeys.refreshToken.rawValue),
            let expirationDateString = userDefaults.string(forKey: CodingKeys.expirationDate.rawValue),
            let expirationDate = Date.fromString(expirationDateString)
        else { return nil }

        return AuthTokens(accessToken: accessToken,
                          refreshToken: refreshToken,
                          expirationDate: expirationDate)
    }

    func deleteTokens() {
        userDefaults.removeObject(forKey: CodingKeys.accessToken.rawValue)
        userDefaults.removeObject(forKey: CodingKeys.refreshToken.rawValue)
        userDefaults.removeObject(forKey: CodingKeys.expirationDate.rawValue)
    }
}
