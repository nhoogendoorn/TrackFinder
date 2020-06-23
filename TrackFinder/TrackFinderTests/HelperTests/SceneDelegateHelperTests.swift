//
//  SceneDelegateHelperTests.swift
//  TrackFinderTests
//
//  Created by Niels Hoogendoorn on 23/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import XCTest
import Foundation
@testable import TrackFinder

class SceneDelegateHelperTests: XCTestCase {
    let searchVC = SearchScreenViewController()
    
    func test_shouldPushSearchViewController_hasTokensNavContainsSearchScreenVC_returnFalse () {
        let hasToken = true
        let rootVC = UIViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.viewControllers.append(searchVC)
        let result = SceneDelegateHelper.shouldPushSearchViewController(hasToken, rootVC: rootVC)
        XCTAssertFalse(result)
    }
    
    func test_shouldPushSearchViewController_hasTokensNavDoesNotContainSearchScreenVC_returnTrue () {
        let hasToken = true
        let rootVC = UIViewController()
        let result = SceneDelegateHelper.shouldPushSearchViewController(hasToken, rootVC: rootVC)
        XCTAssertTrue(result)

    }
    
    func test_shouldPushSearchViewController_hasNoTokensNavContainsSearchScreenVC_returnFalse () {
        let hasToken = false
        let rootVC = UIViewController()
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.viewControllers.append(searchVC)
        let result = SceneDelegateHelper.shouldPushSearchViewController(hasToken, rootVC: rootVC)
        XCTAssertFalse(result)

    }
    
    func test_shouldPushSearchViewController_hasNoTokensNavDoesNotContainSearchScreenVC_returnFalse () {
        let hasToken = false
        let rootVC = UIViewController()
        let result = SceneDelegateHelper.shouldPushSearchViewController(hasToken, rootVC: rootVC)
        XCTAssertFalse(result)

    }
}
