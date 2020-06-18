//
//  BaseRouter.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

protocol BaseRouter {
    typealias Headers = [String: String]

    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: Headers? { get set }
    var parametersEncoding: ParametersEncoding { get }
    var errorResponse: Error { get }
}

extension BaseRouter {
    func printHeader() {
        guard let headers = self.headers else { return }
        print("Request Headers: \(headers)")
    }
    
    func addAuthentication(withNewToken: String? = nil) -> BaseRouter {
        guard let token = withNewToken else { return self }
        var router = self
        router.headers?["Authorization"] = "Bearer \(token)"
        print("Added token: \(token)")
        return router
    }
}

extension URLComponents {
    init(router: BaseRouter) {
        let url = router.baseURL.appendingPathComponent(router.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!
        
        guard
            case let .requestParameters(parameters) = router.task,
            router.parametersEncoding == .url
        else { return }
        
        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}

extension URLRequest {
    
    init(router: BaseRouter) {
        let urlComponents = URLComponents(router: router)
        self.init(url: urlComponents.url!)
        
        httpMethod = router.method.rawValue
        
        router.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }
        
        guard
            case let .requestParameters(parameters) = router.task,
            router.parametersEncoding == .json
        else { return }
        httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

enum ParametersEncoding {
    case url
    case json
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParameters(Parameters)
}

typealias Parameters = [String: Any]
