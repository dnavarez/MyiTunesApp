//
//  DetailVC.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit

//--------------------------------------------------------------------------------
class DetailVC: UIViewController {
    
    // MARK: - Private Properties
    //--------------------------------------------------------------------------------
    // IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // Regular variables
    private var dataSource: [ResultsModel] = []
    //--------------------------------------------------------------------------------
    
    
    // MARK: - Public Properties
    //--------------------------------------------------------------------------------
    var data: ResultsModel?
    //--------------------------------------------------------------------------------
    
    
    // MARK: - ViewController life cycle
    //--------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
        setupNavBar()
        setupTableView()
    }
    //--------------------------------------------------------------------------------
    
    
    
    // MARK: - PRIVATE METHODS
    //--------------------------------------------------------------------------------
    // Initialize properties of class file
    private func initProperties() {
        updateArtWork()
    }
    
    // Setup the table view properties
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "DetailDescCell", bundle: nil), forCellReuseIdentifier: "DetailDescCell")
    }
    
    // Setup the navigation bar properties
    private func setupNavBar() {
        navigationItem.title = "Detail"
    }
    
    // Set art work image
    private func updateArtWork() {
        let artWorkView = DetailArtWorkView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 120))
        artWorkView.artWorkURL = data?.artworkUrl100 ?? nil
        
        tableView.tableHeaderView = artWorkView
    }
}
//--------------------------------------------------------------------------------


// MARK: - UITableView DataSource and Delegate
//--------------------------------------------------------------------------------
extension DetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailDescCell") as! DetailDescCell
        
        switch indexPath.row {
            case 0:
                cell.titleLbl.text = "Track name:"
                cell.detailLbl?.text = data?.trackName
            case 1:
                cell.titleLbl?.text = "Description:"
                cell.detailLbl?.text = data?.longDescription
            case 2:
                cell.titleLbl?.text = "Genre:"
                cell.detailLbl?.text = data?.primaryGenreName
            case 3:
                cell.titleLbl?.text = "Price:"
                cell.detailLbl?.text = "\(data?.trackHdPrice ?? 0.00)"
            default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
//--------------------------------------------------------------------------------