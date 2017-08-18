//
//  UserDetailViewController.swift
//  ReactiveProject
//
//  Created by Harrison Melton on 8/16/17.
//  Copyright © 2017 Harrison Melton. All rights reserved.
//

import UIKit
import ReactiveJSON
import ReactiveSwift
import Result

class UserDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    private var albums = [Album]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUserInfo()
        fetchUserAlbums()
    }
    
    // This function sets information about the view controller instance's User property
    func setUserInfo() {
        nameLabel.text = user?.name
        usernameLabel.text = user?.username
        emailLabel.text = user?.email
    }
    
    // This function fetches albums associated with the view controller instance's User property, and
    // adds them to the UITableView's data source.
    func fetchUserAlbums() {
        ReactiveApi
            .request(endpoint: "albums", method: .Get, parameters: ["userId": user!.id as AnyObject])
            .startWithResult { (result: Result<[[String:Any]], NetworkError>) in
                // Check that values were returned
                if let values = result.value {
                    // Parse data
                    for album in values {
                        let userId = album["userId"] as! Int
                        let id = album["id"] as! Int
                        let title = album["title"] as! String
                        
                        // Add to UITableView's data source
                        self.albums.append(Album(userId: userId, id: id, title: title))
                    }
                    
                    // Back on the main thread, reload the UITableView
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
        }
    }
    
    //  MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UITableView Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch reusable cell from UITableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
        
        // Fetch Album object
        let album = albums[indexPath.row]
        // Set Label using Album's information
        cell.titleLabel.text = album.title
        
        return cell
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Execute if segue was initiated by tap on one of the AlbumCells
        if segue.identifier == "showAlbum" {
            // Find row of cell that was tapped
            let cell = sender as! AlbumCell
            let row = tableView.indexPath(for: cell)?.row
            
            // Executed if there was no issue retrieving the selected cell's IndexPath
            if let row = row {
                // Cast the desination VC to its specific subclass and set appropriate fields
                let vc = segue.destination as! AlbumDetailViewController
                vc.album = albums[row]
            }
        }
    }
}

class AlbumCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}
