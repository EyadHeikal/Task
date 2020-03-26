//
//  ViewController.swift
//  Task
//
//  Created by Eyad Heikal on 3/17/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 13.0, *)

class ViewController: UIViewController {
    
    var db: Firestore?
    var create: Bool?
    let user = (Auth.auth().currentUser?.email)! as String
    var textFile: TextFile?
    var passedCode: String?

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad()
    {
        db = Firestore.firestore()
        super.viewDidLoad()
        textView.delegate = self
        textView.text = "nil"
        //DBManager.shared.saveFile(file: textFile!,text: textView.text!)
        
        if create == true
        {
            DBManager.shared.saveFile(file: textFile!,text:  textView.text!)
        }
        else
        {
            ImportDBM.shared.importFile(fileCode: textFile!.code,onSuccess: (
                DispatchQueue.main.async {
                    self.textView!.text = String(decoding: ImportDBM.shared.fileText, as: UTF8.self)
                }
            ))
            //searchByCode(fileTitle: "eyad", text: textView!.text)
            //DBManager.shared.searchByCode(fileTitle: fileTitle!, text: textView.text)
            
        }
        
    }

    
    
    func searchByCode(fileTitle: String,text:String)
    {

        var myFiles: [String] = []
        let storageRef = Storage.storage().reference().child("files").child("\(textFile!.code).txt")

        DBManager.db2.whereField("code", isEqualTo:  textFile!.code).getDocuments{ (snapShot, error) in
            if let e = error
            {
                print(e.localizedDescription)
            }
            else
            {
                let documents = snapShot!.documents
                for doc in documents
                {
                    let data = doc.data()
                    let userArray = data["users"] as! [String]
                    myFiles = myFiles + userArray
                    print(myFiles)
                }

                if myFiles.contains(DBManager.user)
                {
                    
                    DBManager.db2.whereField("code", isEqualTo:  self.textFile!.code).addSnapshotListener{ (snapShot, error) in
                        if let e = error
                        {
                            print(e.localizedDescription)
                        }
                        else
                        {
                            let storageRef = Storage.storage().reference().child("files").child("\(self.textFile!.code).txt")
                            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                              if let e = error {
                                print(e.localizedDescription)
                                print("error From Here")

                              }
                              else
                              {
                                self.textView.text = String(decoding: data!, as: UTF8.self)
                              }
                            }

                        }

                    }
                }
                else
                {
                    myFiles.append(DBManager.user)
                    DBManager.db2.document(self.textFile!.code).updateData(["users":myFiles]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            let test = self.textView.text!
                            let uploadTask = storageRef.putData(Data(test.utf8), metadata: nil) { (metadata, error) in
                                if let e = error{
                                    print("Failed To Store File Due To The Error:- \(e)")
                                    return
                                }
                                storageRef.downloadURL { (url, error) in
                                    if error == nil
                                    {                                        DBManager.db2.document(fileTitle).updateData(["url" : url!.absoluteString])
                                    }
                                }
                            }
                            uploadTask.observe(.success) { snapshot in
                                print("File Stored")
                            }
                        }
                    }
                }
            }

        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
}

@available(iOS 13.0, *)
extension ViewController: UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.textFile?.code == nil
        {
            
        }
        let storageRef = DBManager.storage.child("\(self.textFile!.code).txt")
            let test = self.textView.text!
            storageRef.putData(Data(test.utf8), metadata: nil) { (metadata, error) in
                if let e = error{
                    print("Failed To Store File Due To The Error:- \(e)")
                    return
                }
                DBManager.db2.document(self.textFile!.code).updateData(["timeStamp": Date().timeIntervalSince1970]){ error in
                if (error != nil) {return}
                }
             print("Updated")
                
            }
        }
        

    }
    
}
