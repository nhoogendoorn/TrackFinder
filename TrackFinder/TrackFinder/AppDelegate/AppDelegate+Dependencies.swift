//
//  AppDelegate+Dependencies.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension AppDelegate {
    func registerDependencies() {
        container.register(AuthenticationServiceProtocol.self) { _ in
            AuthenticationService()
        }.inObjectScope(.container)
        
        container.register(UserPreferencesProtocol.self) { _ in
            UserPreferences()
        }.inObjectScope(.container)
        
        container.register(SearchServiceProtocol.self) { _ in
            SearchService()
        }.inObjectScope(.container)
    }
}
