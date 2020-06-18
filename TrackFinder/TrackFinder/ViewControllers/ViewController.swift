//
//  ViewController.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 16/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

class ViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {

    private let SpotifyClientID = "ad5a0ea0dbd042c080662e6cf9444b5a"
    private let SpotifyRedirectURI = URL(string: "trackfinder://spotify-login-callback")!
    let spotifySecret = "e1b079d5f1ee450094926dcda77800c7"

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
//        configuration.playURI = ""

        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
//        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
//        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
//    lazy var configuration = SPTConfiguration(
//      clientID: SpotifyClientID,
//      redirectURL: SpotifyRedirectURI
//    )

    private var lastPlayerState: SPTAppRemotePlayerState?
    
    // MARK: - Subviews

    private lazy var connectLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect your Spotify account"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var connectButton = ConnectButton(title: "CONNECT")
    private lazy var disconnectButton = ConnectButton(title: "DISCONNECT")

    private lazy var pauseAndPlayButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPauseOrPlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var trackLabel: UILabel = {
        let trackLabel = UILabel()
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        trackLabel.textAlignment = .center
        return trackLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        view.addSubview(connectLabel)
        view.addSubview(connectButton)
        view.addSubview(disconnectButton)
        view.addSubview(imageView)
        view.addSubview(trackLabel)
        view.addSubview(pauseAndPlayButton)

        let constant: CGFloat = 16.0

        connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        connectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disconnectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true

        connectLabel.centerXAnchor.constraint(equalTo: connectButton.centerXAnchor).isActive = true
        connectLabel.bottomAnchor.constraint(equalTo: connectButton.topAnchor, constant: -constant).isActive = true

        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        imageView.bottomAnchor.constraint(equalTo: trackLabel.topAnchor, constant: -constant).isActive = true

        trackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        trackLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: constant).isActive = true
        trackLabel.bottomAnchor.constraint(equalTo: connectLabel.topAnchor, constant: -constant).isActive = true

        pauseAndPlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pauseAndPlayButton.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: constant).isActive = true
        pauseAndPlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pauseAndPlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pauseAndPlayButton.sizeToFit()

        connectButton.sizeToFit()
        disconnectButton.sizeToFit()

        connectButton.addTarget(self, action: #selector(didTapConnect(_:)), for: .touchUpInside)
        disconnectButton.addTarget(self, action: #selector(didTapDisconnect(_:)), for: .touchUpInside)

        updateViewBasedOnConnected()
    }

    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        trackLabel.text = playerState.track.name
        if playerState.isPaused {
            pauseAndPlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            pauseAndPlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    func updateViewBasedOnConnected() {
        if appRemote.isConnected {
            connectButton.isHidden = true
            disconnectButton.isHidden = false
            connectLabel.isHidden = true
            imageView.isHidden = false
            trackLabel.isHidden = false
            pauseAndPlayButton.isHidden = false
        } else {
            disconnectButton.isHidden = true
            connectButton.isHidden = false
            connectLabel.isHidden = false
            imageView.isHidden = true
            trackLabel.isHidden = true
            pauseAndPlayButton.isHidden = true
        }
    }

    func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.imageView.image = image
            }
        })
    }

    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }

    // MARK: - Actions

    @objc func didTapPauseOrPlay(_ button: UIButton) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }

    @objc func didTapDisconnect(_ button: UIButton) {
        if appRemote.isConnected {
            appRemote.disconnect()
        }
    }
    
    func sessionManager(manager: SPTSessionManager, shouldRequestAccessTokenWith code: String) -> Bool {
        log.debug("Code: \(code)")
        return true
    }

    @objc func didTapConnect(_ button: UIButton) {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        log.debug("Has session: " + "\(self.sessionManager.session != nil)")
        let scope: SPTScope = [.userReadEmail, .appRemoteControl]
        self.sessionManager.initiateSession(with: scope, options: .clientOnly)
    }
    
    // MARK: - SPTSessionManagerDelegate

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }

    // MARK: - SPTAppRemoteDelegate

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (_, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }

    // MARK: - SPTAppRemotePlayerAPIDelegate

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }

    // MARK: - Private Helpers

    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
}

class ConnectButton: UIButton {

    fileprivate let buttonBackgroundColor =
        UIColor(red: (29.0 / 255.0), green: (185.0 / 255.0), blue: (84.0 / 255.0), alpha: 1.0)
    fileprivate let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy),
        .foregroundColor: UIColor.white,
        .kern: 2.0
    ]

    init(title: String) {
        super.init(frame: CGRect.zero)
        backgroundColor = buttonBackgroundColor
        contentEdgeInsets = UIEdgeInsets(top: 11.75, left: 32.0, bottom: 11.75, right: 32.0)
        layer.cornerRadius = 20.0
        translatesAutoresizingMaskIntoConstraints = false
        let title = NSAttributedString(string: title, attributes: titleAttributes)
        setAttributedTitle(title, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
