//
//  LoginViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import SafariServices

enum Environment {
    static let spotifyClientId: String = "ad5a0ea0dbd042c080662e6cf9444b5a"
    static let spotifySecretId: String = "e1b079d5f1ee450094926dcda77800c7"
    static var spotifyAuthorizationId: String {
        let combinedString = "\(spotifyClientId):\(spotifySecretId)"
        guard let data = combinedString.data(using: String.Encoding.utf8) else { return "" }
        return data.base64EncodedString()
    }
    static let spotifyRedirectUri: String = "trackfinder://spotify-login-callback"
    static let baseUrl: String = "https://accounts.spotify.com/"
}

class LoginViewController: UIViewController, SPTAppRemoteDelegate, SPTSessionManagerDelegate {
    
    lazy var authService: AuthenticationService? = {
        self.container?.resolve(AuthenticationService.self)
    }()
    
        lazy var configuration: SPTConfiguration = {
            let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
            // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
            // otherwise another app switch will be required
            configuration.playURI = ""

            // Set these url's to your backend which contains the secret to exchange for an access token
            // You can use the provided ruby script spotify_token_swap.rb for testing purposes
    //        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
    //        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
            return configuration
        }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        log.debug("appRemoteDidEstablishConnection")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        log.debug("didFailConnectionAttemptWithError")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        log.debug("didDisconnectWithError")
    }
    
    private let SpotifyClientID = "ad5a0ea0dbd042c080662e6cf9444b5a"
    private let SpotifyRedirectURI = URL(string: "trackfinder://spotify-login-callback")!
    let spotifySecret = "e1b079d5f1ee450094926dcda77800c7"

    let webView = WKWebView()
    
    let button = UIButton()
    
    let api: ApiProtocol = ApiManager()
    
    var loginUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        button.setTitle("Log in", for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func loginButtonPressed() {
        authService?.startSpotifyAuthorization()
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        log.debug("didInitiate")
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        log.error("didFailWith: \(error.localizedDescription)")
    }
}
