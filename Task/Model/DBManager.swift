//
//  DBManager.swift
//  Task
//
//  Created by Eyad Heikal on 3/19/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import Firebase

class DBManager {
    static let shared = DBManager()
    //static let db = Firestore.firestore()
    static let db2 = Firestore.firestore().collection("newFiles")
    static let storage = Storage.storage().reference().child("files")
    static let user = (Auth.auth().currentUser?.email)! as String
    
    private init() {
        
    }
    
    //Authenticattion Functions
    
    //Sign In User
    func signIn(email: String,password: String,onSuccess: (()->())? , onFailure: (()->())?) {
        Auth.auth().signIn(withEmail: email.lowercased(), password: password) { (authData, error) in
            if let e = error {
                print(e.localizedDescription)
                if let failure = onFailure
                {
                    failure()
                    print("Failure")
                }
            }
            else{
                if let success = onSuccess
                {
                    success()
                    print("Success")
                }
                
            }
        }
    }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //Sign Up New User
    func signUp(email: String,password: String,onSuccess: (()->())? , onFailure: (()->())?)
    {
        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { (authData, error) in
            if let e = error {
                print(e.localizedDescription)
                if let failure = onFailure
                {
                    failure()
                    print("Failure")
                }
            }
            else{
                if let success = onSuccess
                {
                    success()
                    print("Success")
                }
                
            }
        }
    }
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Create a new File
    func createNew(fileTitle: String,text:String)
    {
        DBManager.storage.child("\(fileTitle).txt")
        DBManager.db2.document(fileTitle).setData([
            "title": fileTitle,
            "text": text.prefix(30),//textView.text!.prefix(30),
            "users": [(Auth.auth().currentUser?.email)! as String],
            "time": String(Date().timeIntervalSince1970),
            "url": ""
        ]) { err in
            if let err = err
            {
                print("Error writing document: \(err.localizedDescription)")
            }
            else {
                print("File Added")
                let uploadTask = DBManager.storage.putData(Data(text.utf8), metadata: nil) { (metadata, error) in
                    if let e = error{
                        print("Failed To Store File Due To The Error:- \(e)")
                        return
                    }
                    DBManager.storage.downloadURL { (url, error) in
                        if error == nil
                        {
                            print(url!)
                            DBManager.db2.document(fileTitle).updateData(["url" : url!.absoluteString])
                        }
                    }
                }
                uploadTask.observe(.success) { snapshot in
                    print("File Stored")
                }
                }
            }
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Get Files of Current User
    func getFiles() -> [String]{
        
        var fileArray: [String] = []
        DBManager.db2.whereField("users", arrayContains: DBManager.user).addSnapshotListener{ (snapShot, error) in
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
                        
                       fileArray.append(data["title"] as! String)
                        
                   }
                
                }
            
            print(fileArray)
            print("Hello From the Other Side")
        
        }
        print(fileArray)
        return fileArray
    }


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



    //Add Already Existing File
    func searchByCode(fileTitle: String,text:String)
    {

        var myFiles: [String] = []
        let storageRef = Storage.storage().reference().child("files").child("\(fileTitle).txt")

            DBManager.db2.whereField("title", isEqualTo:  fileTitle).getDocuments{ (snapShot, error) in
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
                    DBManager.db2.whereField("title", isEqualTo:  fileTitle).addSnapshotListener{ (snapShot, error) in
                        if let e = error
                        {
                            print(e.localizedDescription)
                        }
                        else
                        {
                            let storageRef = Storage.storage().reference().child("files").child("\(fileTitle).txt")
                            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                              if let e = error {
                                print(e.localizedDescription)
                              }
                              else
                              {
                                //self.textView.text = String(decoding: data!, as: UTF8.self)
                              }
                            }

                        }

                    }
                }
                else
                {
                    myFiles.append(DBManager.user)
                    DBManager.db2.document(fileTitle).updateData(["users":myFiles]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                            let test = ""//self.textView.text!
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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func giveAccessTo(file: String,allAllowed: [String] )
    {
        DBManager.db2.document(file).updateData(["users":allAllowed]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                let test = ""//self.textView.text!
                let uploadTask = DBManager.storage.child(file).putData(Data(test.utf8), metadata: nil) { (metadata, error) in
                    if let e = error{
                        print("Failed To Store File Due To The Error:- \(e)")
                        return
                    }
                    DBManager.storage.child(file).downloadURL { (url, error) in
                        if error == nil
                        {                                        DBManager.db2.document(file).updateData(["url" : url!.absoluteString])
                        }
                    }
                }
                uploadTask.observe(.success) { snapshot in
                    print("File Stored")
                }
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func checkFileExists(fileCode: String ) {
        DBManager.db2.whereField("code", isEqualTo:  fileCode).getDocuments{ (snapShot, error) in
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
                let fileurl = data["url"] as! [String]
                print(fileurl)
            }
        }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func addFileToDB(file: TextFile,text: String)
    {
        addRef(file: file)
        
        saveFile(file: file, text: text)
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func getCurrentUser() -> String {
        return ((Auth.auth().currentUser?.email)! as String)
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func addRef(file: TextFile)
    {
        DBManager.db2.document(file.code).setData([
            "title": file.title,
            Constants.time : file.timeStamp,
            "users": file.users,
            "code": file.code
        ])
    }
    
    func saveFile(file: TextFile,text: String)
    {
        DBManager.storage.child("\(file.code).txt").putData(Data(text.utf8), metadata: nil) { (metadata, error) in
            if let e = error{
                print("Failed To Store File Due To The Error:- \(e.localizedDescription)")
                return
            }
            print("\(file.title).txt Saved To Storage")
        }
    }
    
    
}
