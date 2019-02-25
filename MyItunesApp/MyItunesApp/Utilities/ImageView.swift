//
//  ImageView.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit
import SDWebImage

class ImageView: UIImageView {

    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    var imageChanged: ((_ image: UIImage?) -> Void)?
    
    override var image: UIImage? {
        didSet {
            if image == nil {
                image = UIImage(named: "ic-empty-img")
            }
            
            super.image = image
            imageChanged?(image)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.activityIndicator)
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    
    /**
     * Set the imageView `image` with an `url`, default placeholder if no image.
     *
     * The download is asynchronous and cached.
     *
     * @param url            The url for the image.
     * @param completedBlock A block called when operation has been completed. In case of error the image parameter
     *                       has a default empty image icon.
     */
    func setImageWithURL(url: String, completion: @escaping (_ image: UIImage?) -> Void) {
        
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
        self.imageChanged = { image in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.activityIndicator.isHidden = true
            })
            completion(image)
        }
        
        self.sd_setImage(with: URL(string: url), completed: nil)
    }

}
