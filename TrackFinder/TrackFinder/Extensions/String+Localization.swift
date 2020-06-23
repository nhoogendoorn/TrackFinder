//
//  String+Localization.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension String {
    // MARK: - General Texts
    static let search = NSLocalizedString("Search", comment: "")
    static let appTitle = NSLocalizedString("TrackFinder", comment: "")
    static let startSearching = NSLocalizedString("Start searching \u{1F9D0}", comment: "")
    static let loginExplanation = NSLocalizedString("This app requires access to Spotify in order to final your favorite tracks", comment: "")
    static let playTrack = NSLocalizedString("Play track", comment: "")
    static let album = NSLocalizedString("Album", comment: "")
    
    // MARK: - Button Texts
    static let loginAction = NSLocalizedString("Connect to Spotify", comment: "")
    static let ok = NSLocalizedString("Ok", comment: "")
    
    // MARK: - Errors
    static let noTracksFound = NSLocalizedString("No tracks found", comment: "")
    static let spotifyConnectionError = NSLocalizedString("Could not connect to Spotify", comment: "")
    static let generalError = NSLocalizedString("Something went wrong..", comment: "")
    
    static let noInternetConnectionTitle = NSLocalizedString("No internet connection", comment: "")
    static let noInternetConnectionMessage = NSLocalizedString("Your searches will continue after your reconnect", comment: "")
}
