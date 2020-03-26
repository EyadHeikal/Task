//
//  CreateViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/20/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
@available(iOS 13.0 ,*)
class CreateViewController: UIViewController {
    
    
    @IBOutlet weak var fileNameTextField: UITextField!
    
    @IBOutlet weak var CodeTextField: UITextField!
    var textFile: TextFile?
    
    @IBAction func createFileButton(_ sender: Any) {
        
        if fileNameTextField != nil || CodeTextField != nil
        {
            textFile = TextFile(title: fileNameTextField.text!, code: CodeTextField.text!, users: [DBManager.user])
            DBManager.shared.addRef(file: textFile!)
            let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditingVC") as? ViewController
            nextViewController!.create = true
            nextViewController!.textFile = textFile
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
