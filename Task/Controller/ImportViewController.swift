//
//  ImportViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/20/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

@available(iOS 13.0 ,*)

class ImportViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    var textFile: TextFile?

    @IBAction func importAction(_ sender: Any) {
        if codeTextField.text != nil
        {
            
            let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditingVC") as? ViewController
            nextViewController!.create = false
            nextViewController!.textFile = textFile
            nextViewController!.passedCode = codeTextField.text
            self.navigationController?.pushViewController(nextViewController!, animated: true)
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
