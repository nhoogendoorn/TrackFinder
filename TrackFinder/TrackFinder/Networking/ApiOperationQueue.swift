//
//  ApiOperationQueue.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol ApiOperationQueueProtocol {
    func setOperationQueueSuspsension()
    func applyNewToken(token: String?)
    func addApiOperation(_ operation: ApiRequestOperation)
    func currentTokenIsExpired() -> Bool
}

class ApiOperationQueue: OperationQueue, ApiOperationQueueProtocol, DependencyResolver {
    var hasInternetConnection = true {
        didSet {
            setOperationQueueSuspsension()
        }
    }
    
    static let shared = ApiOperationQueue()
    
    func applyNewToken(token: String?) {
        let requestOperations = self.operations as? [ApiRequestOperation]
        requestOperations?.forEach {
            guard let newToken = token else { return }
            $0.request.setAccessToken(token: newToken)
            $0.startRequest()
        }
    }
    
    func currentTokenIsExpired() -> Bool {
        guard let tokens = getAuthenticationTokens() else { return false }
        return tokens.isExpired
    }
    
    func addApiOperation(_ operation: ApiRequestOperation) {
        self.addOperation(operation)
    }
    
    func setOperationQueueSuspsension() {
        self.isSuspended = suspendOperationQueue()
    }
    
    func suspendOperationQueue() -> Bool {
        // CHECK HERE IF there is active internet connction
        
        return !hasInternetConnection || currentTokenIsExpired()
    }
}
