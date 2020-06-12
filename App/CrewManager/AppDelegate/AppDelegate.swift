//
//  AppDelegate.swift
//  CrewManager
//
//  Created by Muhammad Khan
//  
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import IQKeyboardManagerSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure() // configure firebase in app
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID // set google id in app
        Database.database().isPersistenceEnabled = true // data preisence when internet is not available
        
        // call didFinishLaunchingWithOptions for google and facebook integration
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        self.setupIQKeyboardManager() // setup keyboard manager
        
        return true
    }
    
//    IQKeyboardManager 3rd party library which help use to keybord remove after text
    fileprivate func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true // enalbe in all text field
        IQKeyboardManager.shared.toolbarTintColor = R.ThemeColor.selectedColor // set tootlbar tint color
        IQKeyboardManager.shared.toolbarBarTintColor = R.ThemeColor.unSelectedColor // set toolbar color
        IQKeyboardManager.shared.disabledToolbarClasses.append(LoginViewController.self) // remove toolbar in login page
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            
            return GIDSignIn.sharedInstance().handle(url) // google url handler
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        AppEvents.activateApp() // facebook handler
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url) //google hanler

        //facebook url handler
        let facebookDidHandle = ApplicationDelegate.shared.application(application,open: url,sourceApplication: sourceApplication,annotation: annotation)

        return googleDidHandle || facebookDidHandle // call on need if user login from google or login from facebook
        
    }
    

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
