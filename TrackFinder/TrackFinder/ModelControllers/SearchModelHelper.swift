//
//  SearchModelHelper.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum SearchModelHelper {
    static func allowedToStartSearch(query: String?) -> Bool {
        guard let search = query, search.isEmpty == false else { return false }
        return true
    }
    
    static func showBackground(data: [TrackItem]) -> Bool {
        data.isEmpty
    }
    
    static func getErrorMessage(_ error: NetworkError) -> String {
        error == .noResults ? .noTracksFound : .generalError
    }
}
