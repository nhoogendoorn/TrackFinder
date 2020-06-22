//
//  ApiOperationQueue.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
import Network

protocol ApiOperationQueueProtocol {
    var hasInternetConnection: Bool { get }
    func setSuspensionState()
    func applyNewToken(tokens: AuthTokens?)
    func addApiOperation(_ operation: ApiRequestOperation)
    func currentTokenIsExpired() -> Bool
}

class ApiOperationQueue: OperationQueue, ApiOperationQueueProtocol, DependencyResolver {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var hasInternetConnection = true
    var currentAccessToken: AuthTokens?
    
    static let shared = ApiOperationQueue()
    
    override init() {
        super.init()
        
        addInternetConnectionObserver()
        currentAccessToken = getAuthenticationTokens()
    }
    
    fileprivate func addInternetConnectionObserver() {
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.hasInternetConnection = pathUpdateHandler.status == .satisfied
            }
            self.setSuspensionState()
                        
        }
        monitor.start(queue: self.queue)
    }
    
    func applyNewToken(tokens: AuthTokens?) {
        Self.shared.currentAccessToken = tokens
        
        let requestOperations = self.operations as? [ApiRequestOperation]
        requestOperations?.forEach {
            guard let newToken = tokens?.accessToken else { return }
            $0.request.setAccessToken(token: newToken)
            $0.setTask()
        }
        
    }
    
    func currentTokenIsExpired() -> Bool {
        guard let tokens = currentAccessToken else { return false }
        return tokens.isExpired
    }
    
    func addApiOperation(_ operation: ApiRequestOperation) {
        self.addOperation(operation)
        
        if shouldSuspendQueue() == false {
            operation.task.resume()
        }
    }
    
    func setSuspensionState() {
        let newSuspensionState = self.shouldSuspendQueue()
        let currentlySupsended = self.isSuspended
        self.isSuspended = newSuspensionState
        
        // Only resume the tasks if the queue is currently suspended and the
        // new state is false.
        if currentlySupsended && newSuspensionState == false {
            self.operations.forEach {
                guard let operation = $0 as? ApiRequestOperation else { return }
                operation.task.resume()
            }
        }
    }
    
    func shouldSuspendQueue() -> Bool {
        return !hasInternetConnection || currentTokenIsExpired()
    }
}
