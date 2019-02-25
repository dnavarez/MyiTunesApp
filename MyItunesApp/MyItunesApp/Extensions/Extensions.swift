//
//  Extensions.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit


extension UIViewController {
    
    /// Push a view controller and assign a title to the back button else if none will only display the arrow back
    func pushViewController(_ backItemTitle: String, _ viewController: UIViewController, animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = title
        self.navigationItem.backBarButtonItem = backItem
        
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
}
