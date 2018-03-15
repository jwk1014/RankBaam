//
//  AppDelegate.swift
//  RankBaam
//
//  Created by 김정원 on 2017. 12. 21..
//  Copyright © 2017년 김정원. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import GoogleSignIn




var categories: [Category] = []

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
      
        if window == nil {
          window = UIWindow(frame: UIScreen.main.bounds)
        }
      
        let splashVC = SplashViewController()
        let naviVC = UINavigationController(rootViewController: splashVC)
        naviVC.navigationBar.isHidden = true
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
      
        return SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:]) || SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpen(url)
        }
        
        let google = GIDSignIn.sharedInstance().handle(url,
                                                       sourceApplication: sourceApplication,
                                                       annotation: annotation)
        let facebook = SDKApplicationDelegate.shared.application(application, open: url)
        
        return google || facebook
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
      UserService.signOut()
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("This kind of error occured in Google Login : \(error.localizedDescription)")
        } else {

            let userId = user.userID
            let idToken = user.authentication.idToken
            print("This Google Login userID : \(userId) AND idToken : \(idToken)")
        }
    }
  
}

