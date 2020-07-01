//
//  MockApiManager.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
@testable import TrackFinder

struct MockApiManager<Response: Codable>: ApiProtocol {
    var webApi: WebApiProtocol = MockApi<Response>()
    var authApi: WebApiProtocol = MockApi<Response>()
    
    func injectData(data: Response?, error: NetworkError?) {
        let mockWebApi = webApi as? MockApi<Response>
        mockWebApi?.inject(data: data, error: error)
        let mockAuthApi = authApi as? MockApi<Response>
        mockAuthApi?.inject(data: data, error: error)
    }
}
