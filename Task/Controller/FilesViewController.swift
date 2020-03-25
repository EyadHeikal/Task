//
//  FilesViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/18/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)


class FilesViewController: UIViewController {

    @IBOutlet weak var filesTableView: UITableView!
    
    @IBAction func moreButton(_ sender: Any) {
        performSegue(withIdentifier: "MoreSegue", sender: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1556650445, green: 0.1628865961, blue: 0.1965367602, alpha: 1)

        filesTableView.delegate = self
        filesTableView.dataSource = self
        filesTableView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.168627451, blue: 0.2039215686, alpha: 1)
        filesTableView.separatorColor = #colorLiteral(red: 0.1219933929, green: 0.1276528626, blue: 0.1540242146, alpha: 1)
        
//        DBManager.db2.whereField("users", arrayContains: DBManager.shared.getCurrentUser()).addSnapshotListener{ (snapShot, error) in
//            if let e = error
//            {
//                print(e.localizedDescription)
//            }
//            else
//            {
//                let documents = snapShot!.documents
//                self.titlesArray = []
//                for doc in documents
//                {
//                    let data = doc.data()
//                    self.titlesArray.append(data["title"] as! String)
//                    self.codesArray.append(data["code"] as! String)
//                }
//                DispatchQueue.main.async {
//                    self.filesTableView.reloadData()
//                }
//            }
//        }
        FDBManager.shared.getData(){
            DispatchQueue.main.async {
                self.filesTableView.reloadData()
            }
        }
    }
    
    
//    func alert(title: String,type: UIAlertController.Style,create: Bool){
//        let createAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//        createAlert.addTextField { (textField) in
//            textField.placeholder = "Enter file name here"
//        }
//        createAlert.addTextField { (textField) in
//            textField.placeholder = "Enter access code here"
//        }
//        createAlert.addAction(UIAlertAction(title: "Done", style: .default){[weak self, weak createAlert] action in
//            if (createAlert?.textFields?.first?.text!.isEmpty)! || (createAlert?.textFields?[1].text!.isEmpty)!
//            {
//                return
//            }
//            if create {
//                let file = TextFile(title: (createAlert?.textFields?.first!.text)!, code: (createAlert?.textFields?[1].text)!, users: [DBManager.shared.getCurrentUser()])
//                self?.toNextView(file: file, create: true)
//            }else{
//                ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                let file = TextFile(title: (createAlert?.textFields?.first!.text)!, code: (createAlert?.textFields?[1].text)!, users: [DBManager.shared.getCurrentUser()])
//                self?.toNextView(file: file, create: false)
//            }
//            
//        })
//        createAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//        self.present(createAlert, animated: true, completion: nil)
//    }
    
    
    //GO To Editing File View Controller
//    func toNextView(file: TextFile, create: Bool) {
//        if let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditingVC") as? ViewController {
//
//            //nextViewController.fileTitle = file
//
//            nextViewController.create = create
//            self.navigationController?.pushViewController(nextViewController, animated: true)
//        }
//    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

@available(iOS 13.0, *)

extension FilesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FDBManager.shared.titlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "menlo", size: 15)
        cell.textLabel?.textColor = #colorLiteral(red: 0.01369840626, green: 0.5765583485, blue: 0.6624469439, alpha: 1)
        cell.contentView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.168627451, blue: 0.2039215686, alpha: 1)
        cell.textLabel?.text = "\(FDBManager.shared.titlesArray[indexPath.row]) #Code:\(FDBManager.shared.codesArray[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let textFile = TextFile(title: FDBManager.shared.titlesArray[indexPath.row], code: FDBManager.shared.codesArray[indexPath.row], users: [DBManager.user])
        let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditingVC") as? ViewController
        nextViewController!.create = false
        nextViewController!.textFile = textFile
        nextViewController!.passedCode = FDBManager.shared.codesArray[indexPath.row]
        self.navigationController?.pushViewController(nextViewController!, animated: true)
    }
    
}
