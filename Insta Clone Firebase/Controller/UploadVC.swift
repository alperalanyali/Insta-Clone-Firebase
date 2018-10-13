//
//  SecondViewController.swift
//  Insta Clone Firebase
//
//  Created by Alper on 9.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase


class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentView: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.isEnabled = false
        
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(choosePhoto))
        imageView.addGestureRecognizer(recognizer)
        
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGR)
        
    }
    
    
    @IBAction func postBtnPressed(_ sender: Any) {
        postButton.isEnabled = false
        let mediaFolder = Storage.storage().reference().child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = NSUUID().uuidString
            
            let mediaImageRef = mediaFolder.child("\(uuid).jpeg")
            mediaImageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okBtn)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    mediaImageRef.downloadURL(completion: { (url, error) in
                        if error == nil {
                            
                            
                            let imageURL = url?.absoluteString
                            print("\(String(describing: imageURL))")
                            let currentUser = Auth.auth().currentUser!
                            let post = ["image": imageURL!, "postedby": currentUser.email! , "uuid": uuid,"posttext": self.commentView.text! ] as [String : Any]
                            
                        Database.database().reference().child("users").child(currentUser.uid).child("post").childByAutoId().setValue(post)
                        self.imageView.image = UIImage(named: "selectImage")
                        self.commentView.text = "Write your comment"
                        self.tabBarController?.selectedIndex = 0
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUpload"), object: nil)
                            
                            
                        }
                    })
                }
                
                
            }
            
        }
    }
    
    @objc func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        postButton.isEnabled = true
        
    }
}



