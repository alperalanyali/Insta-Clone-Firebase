//
//  FirstViewController.swift
//  Insta Clone Firebase
//
//  Created by Alper on 9.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage



class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var tableView: UITableView!
    
    var useremailArray = [String]()
    var postcommentArray = [String]()
    var postImageURLArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirebase()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getDataFromFirebase), name: NSNotification.Name(rawValue: "newUpload"), object: nil)
    }
     @objc func getDataFromFirebase() {
        
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            let values = snapshot.value as! NSDictionary
            let post = values["post"] as! NSDictionary
            let postIDs = post.allKeys
            
            for id in postIDs {
                
                let singlePost = post[id] as! NSDictionary
                
                self.useremailArray.append(singlePost["postedby"] as! String)
                self.postcommentArray.append(singlePost["posttext"] as! String)
                self.postImageURLArray.append(singlePost["image"] as! String)
                
            }
            self.tableView.reloadData()
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    @IBAction func logOutPressed(_ sender: Any) {
       UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        delegate.rememberLogin()
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return useremailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.usernameLabel.text = useremailArray[indexPath.row]
        cell.postImage.sd_setImage(with: URL(string: self.postImageURLArray[indexPath.row]), completed: nil)
        cell.commentText.text = postcommentArray[indexPath.row]
    
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
}

