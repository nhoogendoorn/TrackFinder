//
//  LoginViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, DependencyResolver, SPTAppRemoteDelegate, SPTSessionManagerDelegate {
    
    lazy var authService: AuthenticationService? = {
        container?.resolve(AuthenticationService.self)
    }()
    
        lazy var configuration: SPTConfiguration = {
            let configuration = SPTConfiguration(clientID: Environment.spotifyClientId,
                                                 redirectURL: URL(string: Environment.spotifyRedirectUri)!)
            // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
            // otherwise another app switch will be required
            configuration.playURI = .empty

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
    
    let button = UIButton()
    let refreshButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    fileprivate func setButton() {
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        button.setTitle(.loginAction, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        view.addSubview(refreshButton)
        refreshButton.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)

    }
    
    @objc func loginButtonPressed() {
        authService?.startSpotifyAuthorization()
    }
    
    @objc func refreshButtonPressed() {
        authService?.requestNewToken(completion: { (result) in
            switch result {
            case .failure:
                log.error("Failed to refresh Tokens")
            case .success(let response):
                log.debug("New token: \(response.accessToken)")
            }
        })
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        log.debug("didInitiate")
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        log.error("didFailWith: \(error.localizedDescription)")
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        log.debug("appRemoteDidEstablishConnection")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        log.debug("didFailConnectionAttemptWithError")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        log.debug("didDisconnectWithError")
    }
}
