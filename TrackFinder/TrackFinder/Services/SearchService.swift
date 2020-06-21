//
//  SearchService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol { }

class SearchService: SearchServiceProtocol {
    let apiManager = ApiManager()
}
