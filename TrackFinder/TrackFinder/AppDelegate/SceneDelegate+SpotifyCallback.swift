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
        guard let url = URLContexts.first?.url else { return }
        let parameters = rootViewController.appRemote.authorizationParameters(from: url)
        let code = parameters?["code"]
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let authService = appDelegate?.container.resolve(AuthenticationServiceProtocol.self)
        authService?.getAccessToken(code: code, completion: { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .failure:
                self.rootViewController.showError(true)
                log.error("Failed to receive access token")
            case .success:
                self.rootViewController.showError(false)
                self.loadSearchViewControllerIfNotPresented()
            }
        })
    }
}
