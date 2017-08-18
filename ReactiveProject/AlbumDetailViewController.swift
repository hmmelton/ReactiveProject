//
//  AlbumDetailViewController.swift
//  ReactiveProject
//
//  Created by Harrison Melton on 8/16/17.
//  Copyright © 2017 Harrison Melton. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Properties
    var user: User?
    private var images = [String]()
    
    // UIViews
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // This function fetches images from the JSONPlaceholder API
    func fetchImageStrings() {
        // TODO: implement this
    }
    
    // MARK: UICollectionView Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Fetch reusable cell from UICollectionView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
        
        // Fetch image URL
        let imageUrlString = images[indexPath.row]
        // Convert String to URL
        let imageUrl = URL(string: imageUrlString)
        // Set image in cell's UIImageView
        if let imageUrl = imageUrl {
            // If the URL was generated correctly, send it to the UIImageView to display the image
            cell.imageView.af_setImage(withURL: imageUrl)
        }
        
        return cell
    }
    
    // MARK: UICollectionView Flow Layout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Calculate size as the width of the UICollectionView, divided by 3, less 8
        let size = collectionView.bounds.width / 3 - 8
        
        // Return size of cell with equal width and height
        return CGSize(width: size, height: size)
        
    }

}

// This class represents a cell in the Images UICollectionview
class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
