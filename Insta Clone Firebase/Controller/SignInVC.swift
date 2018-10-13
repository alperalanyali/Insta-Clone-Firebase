//
//  SignInVC.swift
//  Insta Clone Firebase
//
//  Created by Alper on 9.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController {

    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    fileprivate func remeberUser(_ result: AuthDataResult?) {
        UserDefaults.standard.set(result!.user.email, forKey: "user")
        UserDefaults.standard.synchronize()
        
        let delegate: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
        delegate.rememberLogin()
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil {
                    self.signInAlert(message: (error?.localizedDescription)!)
                } else {
                    print("Successfully Sign In")
                    self.remeberUser(result)
                
                }
            }
        } else {
            signInAlert(message: "Email and Password are required")
        }
        
    }
    
    func signInAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error != nil {
                    self.signInAlert(message:(error?.localizedDescription)!)
                } else {
    
                    print("Successful Authentication")
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                    self.remeberUser(result)
                }
            }
        } else {
            signInAlert(message: "Email and Password are required")
            
        }
        
       
        
    }
}


extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
