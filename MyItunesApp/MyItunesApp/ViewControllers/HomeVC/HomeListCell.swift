//
//  HomeListCell.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit
import SDWebImage

//--------------------------------------------------------------------------------
class HomeListCell: UITableViewCell {

    // MARK: - Private Properties
    //--------------------------------------------------------------------------------
    @IBOutlet private weak var imgView: ImageView!
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var detailLbl: UILabel!
    //--------------------------------------------------------------------------------
    
    
    // MARK: - Public Properties
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initProperties()
    }
    //--------------------------------------------------------------------------------
    
    
    // MARK: - PRIVATE METHODS
    //--------------------------------------------------------------------------------
    
    // Initialize properties of class file
    private func initProperties() {
        imgView.layer.cornerRadius = 5
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.masksToBounds = true
        
        titleLbl.numberOfLines = 0
        titleLbl.lineBreakMode = .byWordWrapping
        titleLbl.font = UIFont.boldSystemFont(ofSize: 14)
        
        detailLbl.numberOfLines = 0
        detailLbl.lineBreakMode = .byWordWrapping
    }
    //--------------------------------------------------------------------------------
    
    
    // MARK: - PUBLIC METHODS
    //--------------------------------------------------------------------------------
    /// Update UI with the given data model
    func updateUIWithData(_ data: ResultsModel) {
        
        titleLbl.text = "\(data.trackName ?? "")"
        detailLbl.text = "\(data.primaryGenreName ?? "") - \(data.trackHdPrice)"
        
        if let imageURL = data.artworkUrl100 {
            imgView.setImageWithURL(url: imageURL) { (image) in
                if image == nil {
                    // Do something here ...
                }
            }
        }
    }
    //--------------------------------------------------------------------------------
    
    
    // MARK: - EVENTS
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
}
//--------------------------------------------------------------------------------
