//
//  ApiProtocol.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol ApiProtocol {
    var webApi: WebApiProtocol { get }
    var authApi: WebApiProtocol { get }
}
