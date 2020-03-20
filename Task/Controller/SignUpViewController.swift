//
//  SignUpViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/19/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func registerButton(_ sender: Any) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {//If User Entered Email and a Password
                
                DBManager.shared.signUp(email: email,
                                        password: password,
                                        onSuccess:  {
                                            self.performSegue(withIdentifier: "FromRegister",
                                                              sender: nil)},
                                        onFailure: {self.alert()})
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func alert() {
        let alert = UIAlertController(title: "Register Failed" , message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
