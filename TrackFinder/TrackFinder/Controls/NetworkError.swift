//
//  NetworkError.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 19/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case fetchingError, postingError, decodingError
}
