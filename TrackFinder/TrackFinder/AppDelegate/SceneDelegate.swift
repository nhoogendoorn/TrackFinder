//
//  SceneDelegate.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    lazy var rootViewController = LoginViewController()
    
//    var accessToken = ""
//    
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        print("Connected")
//    }
//    
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        print("Failed")
//    }
//    
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        print("Disconnected")
//    }
//    
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        print("player state changed")
//    }
    
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        //        appRemote.authorizeAndPlayURI("spotify:track:20I6sIOMTCkB6w7ryavxtO")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
//        if let _ = rootViewController.appRemote.connectionParameters.accessToken {
//            rootViewController.appRemote.connect()
//        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
//        if rootViewController.appRemote.isConnected {
//            rootViewController.appRemote.disconnect()
//        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        guard let url = URLContexts.first?.url else {
//            return
//        }
//
//        let parameters = rootViewController.appRemote.authorizationParameters(from: url)
//        log.debug("Received parametse: \(parameters)")
//        let code = parameters?["code"]
//
//        requestAuthTokens(code: code) { (result) in
//            switch result {
//            case .failure:
//                log.debug("FAIL")
//            case .success(let data):
//                log.debug("Success")
//                let auth = data.toObject(AuthTokenResponse.self)
//                log.debug(auth)
//            }
//            log.debug("Result")
//        }
//    }
    
//    func requestAuthTokens(code: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
//        guard
//            let code = code
////            let data = "\(Environment.spotifyClientId):\(Environment.spotifySecretId)".data(using: String.Encoding.utf8)
//
//            else { completion(.failure(.postingError)); return }
////        let base64 = data.base64EncodedString()
//        let requestHeaders: [String: String] = [
//            "Authorization": "Basic \(Environment.spotifyAuthorizationId)",
//            "Content-Type": "application/x-www-form-urlencoded"
//        ]
//
//        var urlBodyComponents = URLComponents()
//        urlBodyComponents.queryItems = [
//            URLQueryItem(name: "grant_type", value: "authorization_code"),
//            URLQueryItem(name: "code", value: code),
//            URLQueryItem(name: "redirect_uri", value: "trackfinder://spotify-login-callback"),
//        ]
//
//
//        let url = URL(string: "https://accounts.spotify.com/api/token")!
//
//
////        let url = rootViewController.configuration.tokenSwapURL!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.allHTTPHeaderFields = requestHeaders
////
//        let body = urlBodyComponents.query?.data(using: .utf8)
//        request.httpBody = body
////
////        log.debug("ID: " + rootViewController.configuration.clientID)
////
//        log.debug("URL: \(request.url)")
//        log.debug("BODY: \(String(data: body!, encoding: .utf8))")
//        request.allHTTPHeaderFields?.forEach {
//            log.debug("HEADER \($0.key): \($0.value)")
//        }
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            log.debug(response)
//            if let data = data {
//                data.logJson(prefix: "DATA")
//                completion(.success(data))
//            } else if let error = error {
//                completion(.failure(.postingError))
//            }
//        }.resume()
//    }
    
    
//    func getToken(code: String?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
//        guard let code = code else { completion(.failure(.postingError)); return }
//        let session = URLSession.shared
//
//        let url = URL(string: "https://accounts.spotify.com/api/token")!
//
//
////        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
//
//                var urlComponents = URLComponents()
//                urlComponents.queryItems = [
//        //            URLQueryItem(name: "client_id", value: SpotifyClientID),
//        //            URLQueryItem(name: "client_secret", value: spotifySecret),
//                    URLQueryItem(name: "grant_type", value: "authorization_code"),
//                    URLQueryItem(name: "code", value: code),
//                    URLQueryItem(name: "redirect_uri", value: "trackfinder://spotify-login-callback")
//                ]
//
//        let parameters: Parameters = [
//
//            "grant_type": "client_credentials",
//            "code": code,
//            "redirect_uri": "trackfinder://spotify-login-callback"
//
//        ]
////        components?.queryItems = parameters.map { key, value in
////            return URLQueryItem(name: key, value: String(describing: value))
////        }
//        var request = URLRequest(url: url)
//
//        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//        request.httpBody?.logJson(prefix: "HTTPBOFY")
//        let body = urlComponents.query?.data(using: .utf8)
//        request.httpBody = body
//
//
//        if let data = "\(SpotifyClientID)\(spotifySecret)".data(using: String.Encoding.utf8) {
//            let base64 = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
//            log.debug("Base: \(base64)")
//            request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
//        }
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//
//        log.debug("HEADER: \(request.allHTTPHeaderFields)")
//        request.httpMethod = HTTPMethod.post.rawValue
//
//        session.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                data.logJson(prefix: "DATA")
//                completion(.success(data))
//            } else if let error = error {
//                completion(.failure(.postingError))
//            }
//
//            //            completion(.success("check"))
//        }.resume()
//
//    }
}

