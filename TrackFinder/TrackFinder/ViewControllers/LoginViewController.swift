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
    let logo = UIImageView(image: UIImage(named: "logo"))
    let buttonContainer = UIView()
    let button = UIButton()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        contentStack.axis = .vertical
        contentStack.spacing = Spacing.mediumLarge.rawValue
        view.addSubview(contentStack)
        contentStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Spacing.mediumLarge.rawValue)
            $0.trailing.equalToSuperview().offset(-Spacing.mediumLarge.rawValue)
        }
        
        logo.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }
        logo.contentMode = .scaleAspectFit
               
        button.backgroundColor = .mainColor
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.titleEdgeInsets = UIEdgeInsets(top: Spacing.large.rawValue,
                                              left: Spacing.large.rawValue,
                                              bottom: Spacing.large.rawValue,
                                              right: Spacing.large.rawValue)
        
        button.setTitle(.loginAction, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        label.text = .loginExplanation
        label.textColor = .gray
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        contentStack.addArrangedSubview(logo)
        contentStack.addArrangedSubview(button)
        contentStack.addArrangedSubview(label)
    }
    
    @objc func loginButtonPressed() {
        authService?.startSpotifyAuthorization()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        button.layer.cornerRadius = Spacing.small.rawValue
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
