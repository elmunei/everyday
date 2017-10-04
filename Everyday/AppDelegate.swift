//
//  AppDelegate.swift
//  Everyday
//
//  Created by Elvis Tapfumanei on 9/29/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import UIKit
import Parse
import FBSDKLoginKit
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Enable Local Datastore.
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        
        let parseConfig = ParseClientConfiguration {(ParseMutableClientConfiguration)  in
            
            
            //Accessing pikicha via id & keys
            ParseMutableClientConfiguration.applicationId = "KzIaJ4Ux9hWm8qaVn4qUHHyBU3NSdr5wpLKkmDsL"
            ParseMutableClientConfiguration.clientKey = "MZDHcgZvTyASBMJt0XqkM0rZ5R7b7VvWueB46hwF"
            ParseMutableClientConfiguration.server = "https://parseapi.back4app.com/"
            ParseMutableClientConfiguration.isLocalDatastoreEnabled = true
            
            
        }
        
        Parse.initialize(with: parseConfig)
        
        
        // Track statistics on application openings.
        PFAnalytics.trackAppOpened(launchOptions: launchOptions)
        
       login()
        
        
        
   
        //Facebook Login
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //Facebook Login
        FBSDKAppEvents.activateApp()

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }
    
    func login() {

        // remember user's login
        let username : String? = UserDefaults.standard.string(forKey: "username")

        // if logged in
        if username != nil {

//            ProgressHUD.dismiss()

            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let home = storyboard.instantiateViewController(withIdentifier: "MyProfileCVC") as! MyProfileCVC
            window?.rootViewController = home
        }
    
    }
    
    
}

