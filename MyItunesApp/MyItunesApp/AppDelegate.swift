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

    /*
     *  Note that we use `willFinishLaunching`, not `didFinishLaunching`
     */
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let appWindow = window else {
            fatalError("failed to create window")
        }
        
        /*
         *  The window will be restored either way, but assigning an identifier
         *  adds extra information (e.g., last-used size classes) to the
         *  restoration archive (see below)
         */
        appWindow.restorationIdentifier = "MainWindow"
        
        
        
        // Initializing network services so that we can re-use it's function that would check internet connection
        let _ = NetworkServices()
        
        // Setup Realm migration
        setupRealmMigrationConfig()
        
        
        let homeVC = HomeVC()
        homeVC.restorationIdentifier = "HomeVC"
        
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.restorationIdentifier = "NavController"
        
        appWindow.rootViewController = navVC
        appWindow.makeKeyAndVisible()
        
        return true
    }


    // MARK: - State Restoration protocol adopted by UIApplication delegate
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    

    // Local migration for Realm
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

