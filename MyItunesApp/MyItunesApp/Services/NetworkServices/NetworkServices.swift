//
//  NetworkServices.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//
//  Purpose: This class file is used to detect for any internet connection status

import Foundation
import Reachability

class NetworkServices: NSObject {
    
    var hasInternetConnection = false
    
    var reachability: Reachability!
    
    /// Create a singleton instance
    static let sharedInstance: NetworkServices = { return NetworkServices() }()
    
    
    override init() {
        super.init()
        
        // Initialise reachability
        reachability = Reachability()!
        
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if (NetworkServices.sharedInstance.reachability).connection != .none {
                self.hasInternetConnection = true
            } else {
                self.hasInternetConnection = false
            }
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
        if (NetworkServices.sharedInstance.reachability).connection != .none {
            hasInternetConnection = true
        } else {
            hasInternetConnection = false
        }
        
        print("NetworkServices.hasInternetConnection: \(hasInternetConnection)")
    }
    
    /// Stop the network status notifier
    func stopNotifier() -> Void {
        do {
            try (NetworkServices.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    /// Network is reachable
    func isReachable(completed: @escaping (NetworkServices) -> Void) {
        if (NetworkServices.sharedInstance.reachability).connection != .none {
            completed(NetworkServices.sharedInstance)
        }
    }
    
    /// Network is unreachable
    func isUnreachable(completed: @escaping (NetworkServices) -> Void) {
        if (NetworkServices.sharedInstance.reachability).connection == .none {
            completed(NetworkServices.sharedInstance)
        }
    }
    
    /// Network is reachable via WWAN/Cellular
    func isReachableViaWWAN(completed: @escaping (NetworkServices) -> Void) {
        if (NetworkServices.sharedInstance.reachability).connection == .cellular {
            completed(NetworkServices.sharedInstance)
        }
    }
    
    /// Network is reachable via WiFi
    func isReachableViaWiFi(completed: @escaping (NetworkServices) -> Void) {
        if (NetworkServices.sharedInstance.reachability).connection == .wifi {
            completed(NetworkServices.sharedInstance)
        }
    }
}
