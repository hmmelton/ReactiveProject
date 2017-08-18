//
//  ViewController.swift
//  ReactiveProject
//
//  Created by Harrison Melton on 8/16/17.
//  Copyright © 2017 Harrison Melton. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveJSON
import Result

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // User array used as UITableView's data source
    private var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUsers()
    }
    
    // This function fetches users and adds them to the UITableView's data source.
    func fetchUsers() {
        ReactiveApi
            .request(endpoint: "users")
            .startWithResult { (result: Result<[[String:Any]], NetworkError>) in
                // Check that values were returned
                if let values = result.value {
                    // Parse data
                    for user in values {
                        let id = user["id"] as! Int
                        let name = user["name"] as! String
                        let username = user["username"] as! String
                        let email = user["email"] as! String
                        
                        // Add to UITableView's data source
                        self.users.append(User(id: id, name: name, username: username, email: email))
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
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch reusable cell from UITableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        // Fetch User object
        let user = users[indexPath.row]
        // Set Labels in cell using user's information
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        
        return cell
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Execute if the segue was initiated by a tap on one of the UserCells
        if segue.identifier == "showUser" {
            // Find row of cell that was tapped
            let cell = sender as! UserCell
            let row = tableView.indexPath(for: cell)?.row
            
            // Executed if there was no issue retrieving the selected cell's IndexPath
            if let row = row {
                // Cast the desination VC to its specific subclass and set appropriate fields
                let vc = segue.destination as! UserDetailViewController
                vc.user = users[row]
            }
            
        }
    }

}

// This class represents a cell in the Users UITableView
class UserCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
}

