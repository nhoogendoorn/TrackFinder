//
//  UIViewController+Extension.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 18/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation
import Swinject

extension UIViewController {
    var container: Container? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.container
    }
}
