//
//  ApiRequestOperation.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 20/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class ApiRequestOperation: Operation {
    var task: URLSessionDataTask!
    private var session: URLSession = URLSession.shared
    
    var request: SpotifyRequest
    let completion: (Result<Data, NetworkError>) -> Void
    
    init(request: SpotifyRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        self.request = request
        self.completion = completion
        super.init()
        setTask()
    }
    
    func addNewAccessToken(token: String) {
        request.setAccessToken(token: token)
    }
    
    func setTask() {
        let request = self.request.generateRequest()
        log.info("Add urlRequest: \(request.url?.absoluteString ?? .empty)")
        self.task = session.dataTask(with: request, completionHandler: { (data, _, _) in
            data?.logDataResponse(prefix: "Data")
            if let response = data {
                self.completion(.success(response))
            } else {
                self.completion(.failure(.fetchingError))
            }
        })
    }
}
