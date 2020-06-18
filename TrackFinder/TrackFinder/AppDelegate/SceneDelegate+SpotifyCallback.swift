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
        let authService = appDelegate?.container.resolve(AuthenticationService.self)
        authService?.getAccessToken(code: code, completion: { (result) in
            switch result {
            case .failure:
                log.debug("FAIL")
            case .success(let data):
                log.debug("Success")
                log.debug(data)
                
                // SAVE TOKEN TO USERDEFAULTS
            }
        })
    }
}
