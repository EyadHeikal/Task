//
//  FBDManager.swift
//  Task
//
//  Created by Eyad Heikal on 3/25/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation
import Firebase

class FDBManager {
    
    static let shared = FDBManager()
    private init() {
        
    }
    
    static let db2 = Firestore.firestore().collection("newFiles")
    static let storage = Storage.storage().reference().child("files")
    static let user = (Auth.auth().currentUser?.email)! as String
    
    var titlesArray: [String] = []
    var codesArray: [String]  = []
    
    func getData(onSuccess: @escaping ()->()) {
        DBManager.db2.whereField("users", arrayContains: DBManager.shared.getCurrentUser()).addSnapshotListener{ (snapShot, error) in
            if let e = error
            {
                print(e.localizedDescription)
                return
            }
            else
            {
                let documents = snapShot!.documents
                self.titlesArray = []
                for doc in documents
                {
                    let data = doc.data()
                    self.titlesArray.append(data["title"] as! String)
                    self.codesArray.append(data["code"] as! String)
                }
                //DispatchQueue.main.async {
                    //self.filesTableView.reloadData()
                    onSuccess()
                //}
            }
        }
    }
    
    
    
}
