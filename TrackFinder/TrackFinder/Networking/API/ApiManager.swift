//
//  ApiManager.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

struct ApiManager: ApiProtocol, DependencyResolver {
    var webApi: WebApiProtocol = SpotifyApi()
}
