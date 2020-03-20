//
//  ChooseViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/20/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {

    @IBAction func createNewFileButton(_ sender: Any) {
        performSegue(withIdentifier: "Create", sender: nil)
    }
    @IBAction func ImportFileButton(_ sender: Any) {
        performSegue(withIdentifier: "Import", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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

}
