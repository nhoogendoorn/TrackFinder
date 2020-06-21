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
    func setOperationQueueSuspsension()
    func applyNewToken(token: String?)
    func addApiOperation(_ operation: ApiRequestOperation)
    func currentTokenIsExpired() -> Bool
}

class ApiOperationQueue: OperationQueue, ApiOperationQueueProtocol, DependencyResolver {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    var hasInternetConnection = true
    
    static let shared = ApiOperationQueue()
    
    override init() {
        super.init()
        
        addInternetConnectionObserver()
    }
    
    fileprivate func addInternetConnectionObserver() {
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.hasInternetConnection = pathUpdateHandler.status == .satisfied
                self.setOperationQueueSuspsension()
            }
        }
        monitor.start(queue: self.queue)
    }
    
    func applyNewToken(token: String?) {
        let requestOperations = self.operations as? [ApiRequestOperation]
        requestOperations?.forEach {
            guard let newToken = token else { return }
            $0.request.setAccessToken(token: newToken)
            $0.setTask()
        }
        
    }
    
    func currentTokenIsExpired() -> Bool {
        guard let tokens = getAuthenticationTokens() else { return false }
        return tokens.isExpired
    }
    
    func addApiOperation(_ operation: ApiRequestOperation) {
        self.addOperation(operation)
        if suspendOperationQueue() == false {
            operation.task.resume()
        }
    }
    
    func setOperationQueueSuspsension() {
        DispatchQueue.main.async {
            let shouldBeSuspended = self.suspendOperationQueue()
            let currentlySupsended = self.isSuspended
            self.isSuspended = shouldBeSuspended
            
            if currentlySupsended && shouldBeSuspended == false {
                self.operations.forEach {
                    guard let operation = $0 as? ApiRequestOperation else { return }
                    operation.task.resume()
                }
            }
        }        
    }
    
    func suspendOperationQueue() -> Bool {
        return !hasInternetConnection || currentTokenIsExpired()
    }
}
