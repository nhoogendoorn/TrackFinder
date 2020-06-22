//
//  SceneDelegate+SpotifyCallback.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension SceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
        let parameters = rootViewController.appRemote.authorizationParameters(from: url)
        log.debug("Received parametse: \(String(describing: parameters))")
        let code = parameters?["code"]
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let authService = appDelegate?.container.resolve(AuthenticationServiceProtocol.self)
        authService?.getAccessToken(code: code, completion: { [weak self] result in
            guard let `self` = self else { return }
            self.loadSearchViewControllerIfNotPresented()
            switch result {
            case .failure:
                log.error("Failed to receive access token")
            case .success:
                log.debug("Received access token")
            }
        })
    }
}
