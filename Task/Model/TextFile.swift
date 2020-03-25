//
//  TextFile.swift
//  Task
//
//  Created by Eyad Heikal on 3/17/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation

struct TextFile: Hashable//: Codable
{
    let title: String
    let code :String    //= String(Int.random(in: 0..<999999999))
    let users: [String]
    let timeStamp = String(Date().timeIntervalSince1970)
}

