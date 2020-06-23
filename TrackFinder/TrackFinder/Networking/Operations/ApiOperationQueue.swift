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
    var currentTokenIsExpired: Bool { get }
    func setSuspensionState()
    func applyNewToken(tokens: AuthTokens?)
    func addApiOperation(_ operation: ApiRequestOperation)
}

class ApiOperationQueue: OperationQueue, ApiOperationQueueProtocol, DependencyResolver {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var hasInternetConnection = true
    var currentAccessToken: AuthTokens?
    var currentTokenIsExpired: Bool {
        guard let tokens = currentAccessToken else { return false }
        return tokens.isExpired
    }
    
    static let shared = ApiOperationQueue()
    
    override init() {
        super.init()
        addInternetConnectionObserver()
        currentAccessToken = getAuthenticationTokens()
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
    
    func addApiOperation(_ operation: ApiRequestOperation) {
        self.addOperation(operation)
        
        if QueueHelper.shouldSuspendQueue(self) == false {
            operation.task.resume()
        }
    }
    
    func setSuspensionState() {
        let newSuspensionState = QueueHelper.shouldSuspendQueue(self)
        self.isSuspended = newSuspensionState
        
        // Continue tasks when queue is no longer suspended.
        if newSuspensionState == false {
            self.operations.forEach {
                guard let operation = $0 as? ApiRequestOperation else { return }
                operation.task.resume()
            }
        }
    }
}

extension ApiOperationQueue {
    private func addInternetConnectionObserver() {
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.hasInternetConnection = pathUpdateHandler.status == .satisfied
            }
            self.setSuspensionState()
            
        }
        monitor.start(queue: self.queue)
    }
}
