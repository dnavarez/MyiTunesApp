//
//  AppDelegate.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit
import RealmSwift
import AlamofireNetworkActivityLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initializing network services so that we can re-use it's function that would check internet connection
        let _ = NetworkServices()
        
        // Setup Realm migration
        setupRealmMigrationConfig()
        
        // Load the Home view controller
        self.window?.rootViewController =  UINavigationController(rootViewController: HomeVC())
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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

    // MARK: - State Restoration protocol adopted by UIApplication delegate
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        // encode any state at the app delegate level
        
    }
    
    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        UIApplication.shared.extendStateRestoration()
        DispatchQueue.main.async {
            UIApplication.shared.completeStateRestoration()
        }
        
        if let restoreBundleVersion =   coder.decodeObject(forKey: UIApplication.stateRestorationBundleVersionKey) as? String{
            print("Restore bundle version: \(restoreBundleVersion)")
        }
        
        if let restoreUserInterfaceIdiom =   coder.decodeObject(forKey: UIApplication.stateRestorationUserInterfaceIdiomKey) as? Int{
            print("Restore User Interface Idiom: \(restoreUserInterfaceIdiom)")
        }
    }

    //Local migration for Realm
    func setupRealmMigrationConfig() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 0,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        print("Realm Path : \(String(describing: config.fileURL))")
    }
}

