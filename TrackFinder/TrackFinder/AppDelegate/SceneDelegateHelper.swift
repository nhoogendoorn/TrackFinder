//
//  SceneDelegateHelper.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

enum SceneDelegateHelper {
    static func shouldPushSearchViewController(_ hasTokens: Bool, rootVC: UIViewController) -> Bool {
        let vcsInNavigation = rootVC.navigationController?.viewControllers
        let navigationContainsSearchVC = vcsInNavigation?.contains(where: { $0 is SearchScreenViewController }) == true
        return hasTokens && !navigationContainsSearchVC
    }
}
