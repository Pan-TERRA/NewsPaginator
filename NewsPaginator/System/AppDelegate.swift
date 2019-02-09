//
//  AppDelegate.swift
//  NewsPaginator
//
//  Created by Vlad Krut on 2/5/19.
//  Copyright © 2019 Vlad Krut. All rights reserved.
//

import UIKit
import ConvenientKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let initialVC = NewsListVC()
        let navigationRootController = UINavigationController(rootViewController: initialVC)
        
        window?.set(toRootViewController: navigationRootController)
        
        return true
    }

}
