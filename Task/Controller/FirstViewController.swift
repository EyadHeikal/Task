//
//  FirstViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/18/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func toRegisterButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.toRegisterView, sender: nil)
    }
    @IBAction func toSignInButton(_ sender: Any) {
        performSegue(withIdentifier: Constants.toSignInView, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
