//
//  LoginViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController, DependencyResolver {    
    lazy var authService: AuthenticationServiceProtocol? = {
        container?.resolve(AuthenticationServiceProtocol.self)
    }()
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: Environment.spotifyClientId,
                                             redirectURL: URL(string: Environment.spotifyRedirectUri)!)
        return configuration
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    let contentStack = UIStackView()
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    let loginButton = UIButton()
    let loginExplanationLabel = UILabel()
    let loginErrorMessageLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setViews()
    }
    
    @objc func loginButtonPressed() {
        authService?.startSpotifyAuthorization()
    }
    
    func showError(_ show: Bool) {
        DispatchQueue.main.async {
            self.loginErrorMessageLabel.text = show ? .spotifyConnectionError : .empty
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginButton.layer.cornerRadius = Spacing.small.rawValue
    }
}

extension LoginViewController: SPTAppRemoteDelegate {
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
