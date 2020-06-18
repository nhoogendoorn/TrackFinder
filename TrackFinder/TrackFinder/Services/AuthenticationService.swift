//
//  AuthenticationService.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum RoutingPath: String {
    case startAuthorization = "authorize"
    case getToken = "api/token"
    
    static func url(for path: RoutingPath) -> URL {
        URL(string: Environment.baseUrl + path.rawValue)!
    }
}

extension URLRequest {
    init(routingPath: RoutingPath) {
        let url = RoutingPath.url(for: routingPath)
        self.init(url: url)
    }
}

class AuthenticationService {
    func startSpotifyAuthorization() {
        let request = URLRequest(routingPath: .startAuthorization)
        guard let url = request.url else { return }
        
        let queryItems = [
            URLQueryItem(name: "client_id", value: Environment.spotifyClientId),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: Environment.spotifyRedirectUri),
            URLQueryItem(name: "scope", value: "user-read-private%20user-read-email"),
            URLQueryItem(name: "state", value: "34fFs29kd09")
        ]
        
        var urlBodyComponents = URLComponents(string: url.absoluteString)
        urlBodyComponents?.queryItems = queryItems
        guard let finalUrl = urlBodyComponents?.url else { return }
        guard UIApplication.shared.canOpenURL(finalUrl) else { return }
        UIApplication.shared.open(finalUrl)
    }
    
    func getAccessToken(code: String?, completion: @escaping (Result<AuthTokenResponse, NetworkError>) -> Void) {
        
        guard let code = code else { completion(.failure(.postingError)); return }
        
        let requestHeaders: [String: String] = [
            "Authorization": "Basic \(Environment.spotifyAuthorizationId)",
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        var urlBodyComponents = URLComponents()
        urlBodyComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "trackfinder://spotify-login-callback")
        ]
        
        var request = URLRequest(routingPath: .getToken)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = requestHeaders
        
        let body = urlBodyComponents.query?.data(using: .utf8)
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, _, _) in
            guard let data = data else {
                completion(.failure(.postingError))
                return
            }
            let result = data.getNetworkResult(AuthTokenResponse.self)
            
            completion(result)
        }.resume()
    }
}
