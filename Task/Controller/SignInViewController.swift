//
//  SignInViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/18/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func signInButton(_ sender: Any) {
        
        
        if let email = emailTextField.text, let password = passwordTextField.text {//If User Entered Email and a Passord Sign in
            //If Login is Successfull, Show The following ViewController
            //If Login Fails, Alert Will Pop Up
            DBManager.shared.signIn(email: email,
                                    password: password,
                                    onSuccess:  {
                                        self.performSegue(withIdentifier: Constants.toFilesViewTable,
                                                          sender: nil)},
                                    onFailure: {self.alert()})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "anas@anas.com"
        passwordTextField.text = "123456"
    }
    
    func alert() {
        let alert = UIAlertController(title: "Sign In Failed" , message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    


}
