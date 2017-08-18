//
//  AlbumDetailViewController.swift
//  ReactiveProject
//
//  Created by Harrison Melton on 8/16/17.
//  Copyright © 2017 Harrison Melton. All rights reserved.
//

import UIKit
import AlamofireImage
import ReactiveSwift
import ReactiveJSON
import Result

class AlbumDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Properties
    var album: Album?
    private var images = [String]()
    
    // UIViews
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImageStrings()
    }
    
    // This function fetches images from the JSONPlaceholder API
    func fetchImageStrings() {
        ReactiveApi
            .request(endpoint: "photos", method: .Get, parameters: ["albumId": album!.id as AnyObject])
            .startWithResult { (result: Result<[[String:Any]], NetworkError>) in
                // Check that values were returned
                if let values = result.value {
                    // Parse data
                    for image in values {
                        let thumnailUrl = image["thumbnailUrl"] as! String
                        
                        // Add URL to UICollectionView's data source
                        self.images.append(thumnailUrl)
                    }
                    
                    // Back on the main thread, reload the UITableView
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
        }
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
