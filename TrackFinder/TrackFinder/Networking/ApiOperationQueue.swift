//
//  ApiOperationQueue.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class ApiOperationQueue: OperationQueue {
    static let shared = ApiOperationQueue()
    
    func applyNewToken(token: String?) {
        let requestOperations = self.operations as? [ApiRequestOperation]
        requestOperations?.forEach {
            guard let newToken = token else { return }
            $0.request.addNewAccessToken(token: newToken)
            $0.startRequest()
        }
    }
}
