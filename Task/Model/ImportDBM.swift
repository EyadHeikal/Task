//
//  ImportDBM.swift
//  Task
//
//  Created by Eyad Heikal on 3/25/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import Firebase

class ImportDBM {
    static let shared = ImportDBM()
    private init(){
        
    }
    
    static let db2 = Firestore.firestore().collection("newFiles")
    static let storage = Storage.storage().reference().child("files")
    static let user = (Auth.auth().currentUser?.email)! as String
    
    //var textFile = TextFile(title: "", code: "", users: user)
    var fileText = Data()
    var allAllowed :[String] = []
    
    func updateLastEditTime(fileCode: String) {
        ImportDBM.db2.document(fileCode).updateData([Constants.time : Date().timeIntervalSince1970])
        print("Filed last edit time updated")
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func getFile(fileCode: String, onSuccess:@escaping @autoclosure ()->()) {
        
        let downloadTask = ImportDBM.storage.child("\(fileCode).txt").getData(maxSize: 1 * 1024 * 1024) {
            (data, error) in
            
            if let e = error {
                print("Failed To Get File Due To The Error:- \(e.localizedDescription)")
                return
            }
            ImportDBM.shared.fileText = data!
            print(String(decoding: ImportDBM.shared.fileText, as: UTF8.self ))
            onSuccess()
        }
        
        downloadTask.observe(.success) { snapshot in
            print("File Downloaded")
        }
        
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func giveAccessTo(fileCode: String, onSuccess: @escaping @autoclosure ()->())
    {
        ImportDBM.db2.document(fileCode).updateData([Constants.user : ImportDBM.shared.allAllowed]) { err in
            if let e = err {
                print("Error writing document: \(e)")
                return
            }
            self.getFile(fileCode: fileCode,onSuccess: onSuccess())
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func dun(fileCode: String, onSuccess: @escaping @autoclosure ()->()) {
        
        ImportDBM.db2.whereField("code", isEqualTo:  fileCode).addSnapshotListener{
            (snapShot, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            self.getFile(fileCode: fileCode, onSuccess: onSuccess())
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func importFile(fileCode: String, onSuccess: @escaping @autoclosure ()->()) {
        
        DBManager.db2.whereField("code", isEqualTo:  fileCode).getDocuments{
            (snapShot, error) in
            
            if let e = error {
                print("File Not Found \(e.localizedDescription)")
                return
            }
            else
            {
                let documents = snapShot!.documents
                for doc in documents
                {
                    let data = doc.data()
                    let userArray = (data["users"] as! [String])
                    ImportDBM.shared.allAllowed += userArray
                }
                if ImportDBM.shared.allAllowed.contains(ImportDBM.user) {
                    self.getFile(fileCode: fileCode, onSuccess: onSuccess())
                } else {
                    self.giveAccessTo(fileCode: fileCode, onSuccess: onSuccess())
                }
            }
        }
    }
   //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
//func searchByCode(fileTitle: String,text:String)
//{
//
//    var myFiles: [String] = []
//    let storageRef = Storage.storage().reference().child("files").child("\(textFile!.code).txt")
//
//    DBManager.db2.whereField("code", isEqualTo:  textFile!.code).getDocuments{ (snapShot, error) in
//        if let e = error
//        {
//            print(e.localizedDescription)
//        }
//        else
//        {
//            let documents = snapShot!.documents
//            for doc in documents
//            {
//                let data = doc.data()
//                let userArray = data["users"] as! [String]
//                myFiles = myFiles + userArray
//                print(myFiles)
//            }
//
//            if myFiles.contains(DBManager.user)
//            {
//
//                DBManager.db2.whereField("code", isEqualTo:  self.textFile!.code).addSnapshotListener{ (snapShot, error) in
//                    if let e = error
//                    {
//                        print(e.localizedDescription)
//                    }
//                    else
//                    {
//                        let storageRef = Storage.storage().reference().child("files").child("\(self.textFile!.code).txt")
//                        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                          if let e = error {
//                            print(e.localizedDescription)
//                            print("error From Here")
//
//                          }
//                          else
//                          {
//                            self.textView.text = String(decoding: data!, as: UTF8.self)
//                          }
//                        }
//
//                    }
//
//                }
//            }
//            else
//            {
//                myFiles.append(DBManager.user)
//                DBManager.db2.document(self.textFile!.code).updateData(["users":myFiles]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
//                        let test = self.textView.text!
//                        let uploadTask = storageRef.putData(Data(test.utf8), metadata: nil) { (metadata, error) in
//                            if let e = error{
//                                print("Failed To Store File Due To The Error:- \(e)")
//                                return
//                            }
//                            storageRef.downloadURL { (url, error) in
//                                if error == nil
//                                {                                        DBManager.db2.document(fileTitle).updateData(["url" : url!.absoluteString])
//                                }
//                            }
//                        }
//                        uploadTask.observe(.success) { snapshot in
//                            print("File Stored")
//                        }
//                    }
//                }
//            }
//        }
//
//    }
//
//}
