//
//  HomeVC.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit
import SVProgressHUD

//--------------------------------------------------------------------------------
class HomeVC: UIViewController {

    // MARK: - Private Properties
    //--------------------------------------------------------------------------------
    // IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // Regular variables
    private var dataSource: [ResultsModel] = []
    //--------------------------------------------------------------------------------
    
    
    // MARK: - Public Properties
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    
    
    // MARK: - ViewController life cycle
    //--------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        initProperties()
        setupNavBar()
        setupTableView()
        loadData()
    }
    //--------------------------------------------------------------------------------


    
    // MARK: - PRIVATE METHODS
    //--------------------------------------------------------------------------------
    // Initialize properties of class file
    private func initProperties() {
        
    }
    
    // Setup the table view properties
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "HomeListCell", bundle: nil), forCellReuseIdentifier: "HomeListCell")
    }
    
    // Setup the navigation bar properties
    private func setupNavBar() {
        navigationItem.title = "Movie List"
    }
    
    // Load the data from iTunes Search API or from local database
    private func loadData() {
        // Show a progress indicator that we are trying to process/download something
        SVProgressHUD.show()
        
        // This is optional but since this view controller is the first being called when app loads and since we are
        // still initializing th NetWorkServices so we
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // If has internet connection try to retrieve latest list from server
            if NetworkServices.sharedInstance.hasInternetConnection {
                RestAPIServices.sharedInstance.GETiTunesSearch { (response, err) in
                    if response != nil {
                        response?.results.forEach({ data in
                            // Store or update result/data on local database using Realm platform
                            RealmService.sharedInstance.addUpdate(data)
                            
                            self.dataSource.append(data)
                        })
                        
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                    }
                }
            } else {
                // Since no internet connection for whatsoever, try to load data from previously saved list from server if there are any
                let result = RealmService.sharedInstance.realm.objects(ResultsModel.self)
                
                if result.count > 0 {
                    // We are mapping the array result from Results<Element> into [ResultsModel]
                    self.dataSource = result.map({$0})
                }
                
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    //--------------------------------------------------------------------------------
    
    
    // MARK: - PRIVATE METHODS
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    
    
    // MARK: - EVENTS
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    

}
//--------------------------------------------------------------------------------

// MARK: - UITableView DataSource and Delegate
//--------------------------------------------------------------------------------
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeListCell") as! HomeListCell
        
        let data = dataSource[indexPath.row]
        
        cell.updateUIWithData(data)
        
        // Just for UI color separation to make it look good to see
        if Int(indexPath.row) % 2 == 0 {
            cell.backgroundColor = UIColor(red: 0.898, green: 0.945, blue: 0.957, alpha: 1.00)
        } else {
            cell.backgroundColor = .white
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataSource[indexPath.row]
        
        let detailVC = DetailVC()
        detailVC.data = data
        
        pushViewController("", detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
//--------------------------------------------------------------------------------
