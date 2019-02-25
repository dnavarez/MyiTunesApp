//
//  DetailArtWorkView.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit

class DetailArtWorkView: UIView {

    // MARK: - Private Properties
    //--------------------------------------------------------------------------------
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var imgView: ImageView!
    //--------------------------------------------------------------------------------
    
    
    
    // MARK: - Public Properties
    //--------------------------------------------------------------------------------
    var artWorkURL: String?
    //--------------------------------------------------------------------------------
    
    
    
    // MARK: - View Life Cycle
    //--------------------------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateArtWorkByURL()
    }
    //--------------------------------------------------------------------------------
    
    
    // MARK: - PRIVATE METHODS
    //--------------------------------------------------------------------------------
    
    // Initialize properties of class file
    private func initProperties() {
        Bundle.main.loadNibNamed("DetailArtWorkView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        imgView.layer.cornerRadius = 5
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.masksToBounds = true
    }
    
    // Update artwork image
    private func updateArtWorkByURL() {
        if let url = artWorkURL {
            imgView.setImageWithURL(url: url) { (image) in
                // Do something here...
            }
        }
    }
    //--------------------------------------------------------------------------------
    
    
    
    // MARK: - PUBLIC METHODS
    //--------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------
    

}
