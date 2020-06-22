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
    
    lazy var authService: AuthenticationServiceProtocol? = {
        container?.resolve(AuthenticationServiceProtocol.self)
    }()
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Environment.spotifyClientId,
                                             redirectURL: URL(string: Environment.spotifyRedirectUri)!)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = .empty
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
    
    let contentStack = UIStackView()
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    let loginButton = UIButton()
    let loginExplanationLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setViews()
    }
    
    @objc func loginButtonPressed() {
        authService?.startSpotifyAuthorization()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton.layer.cornerRadius = Spacing.small.rawValue
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
