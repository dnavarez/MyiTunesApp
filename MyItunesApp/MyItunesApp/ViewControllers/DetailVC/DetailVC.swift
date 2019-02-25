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
    //--------------------------------------------------------------------------------
    
    
    // MARK: - Public Properties
    //--------------------------------------------------------------------------------
    private var data: ResultsModel?
    //--------------------------------------------------------------------------------
    
    
    // MARK: - ViewController life cycle
    //--------------------------------------------------------------------------------
    
    required init(data: ResultsModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
        
        restorationIdentifier = String(describing: type(of: self))
        
        /*
         *  The class specified here must conform to `UIViewControllerRestoration`,
         *  as explained below. If not set, you'd get a second chance to create the
         *  view controller on demand in the app delegate.
         */
        restorationClass = type(of: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        data = nil
        assert(false, "init(coder:) not supported. Please use init(data:) instead.")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProperties()
    }
    //--------------------------------------------------------------------------------
    
    
    // MARK: - PRIVATE METHODS
    //--------------------------------------------------------------------------------
    // Initialize properties of class file
    private func initProperties() {
        setupNavBar()
        setupTableView()
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


// MARK:- UIViewControllerRestoration
//--------------------------------------------------------------------------------
extension DetailVC: UIViewControllerRestoration {
    
    /*
     *  Provide a new instance on demand, including decoding of its previous state,
     *  which would else be done in `decodeRestorableStateWithCoder(coder:)`
     */
    static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        assert(String(describing: self) == identifierComponents.last, "unexpected restoration path: \(identifierComponents)")
        
        guard let trackId = coder.decodeObject(forKey: "trackId") as? Int else {
            print("decoding the trackId failed")
            // it does not make sense to create an empty controller of this type:
            // abort state restoration at this point
            return nil
        }
        
        // Let's get the data filtered by trackId on database
        if let data = RealmService.sharedInstance.realm.object(ofType: ResultsModel.self, forPrimaryKey: trackId) {
            return self.init(data: data)
        }
        
        return nil
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        // preserve user model object.
        coder.encode(self.data?.trackId, forKey: "trackId")
    }
    
    /*
     *  We have decoded our state in `viewControllerWithRestorationIdentifierPath(_:coder:)`
     *  already.
     */
    // override func decodeRestorableState(with coder: NSCoder) {
    //     super.decodeRestorableState(with: coder)
    // }
}
//--------------------------------------------------------------------------------
