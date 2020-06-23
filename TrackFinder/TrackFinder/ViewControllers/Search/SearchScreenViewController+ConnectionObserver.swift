//
//  SearchScreenViewController+ConnectionObserver.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension SearchScreenViewController {
    func addInternetConnectionObserver() {
        monitor.pathUpdateHandler = { [weak self] pathUpdateHandler in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                let newConnectionState = pathUpdateHandler.status == .satisfied
                if SearchModelHelper.showNoConnectionAlert(self.hasInternetConnection, newConnectionState) {
                    self.showNoConnectionAlert()
                }                
                self.hasInternetConnection = newConnectionState
            }
        }
        monitor.start(queue: self.queue)
    }
    
    func showNoConnectionAlert() {
        let alert = UIAlertController(title: .noInternetConnectionTitle,
                                      message: .noInternetConnectionMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .ok, style: .default, handler: nil))

        self.present(alert, animated: true)

    }
}
