//
//  AppDelegate.swift
//  Rx_TubeApp
//
//  Created by HIroshi Hosoda on 2017/04/06.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let viewModel = ItemListViewModel(provider: YoutubeProvider, type: ItemListViewType.HD)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = UINavigationController(rootViewController: ItemListViewController(viewModel: viewModel))
        window?.makeKeyAndVisible()
        
        return true
    }

}

