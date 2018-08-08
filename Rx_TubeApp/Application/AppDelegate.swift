//
//  AppDelegate.swift
//  Rx_TubeApp
//
//  Created by HIroshi Hosoda on 2017/04/06.
//  Copyright © 2017 HIroshi Hosoda. All rights reserved.
//

import UIKit
import RxSwift
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        // Config Firebase
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Config Coordinator
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[.sourceApplication] as? String,
                                                 annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
        
        if let _ = error {
            // TODO: Implement Error Handling
            return
        }
        
        guard let authentication = user?.authentication else { return }
        let credential = GoogleAuthProvider.credential(
            withIDToken: authentication.idToken,
            accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            if let _ = error {
                // TODO: Implement Error Handling
                return
            }
            
            
        }
    }
}
