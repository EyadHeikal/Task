//
//  Message.swift
//  Task
//
//  Created by Eyad Heikal on 3/18/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import Foundation

struct Message {
    let sender: String
    let body: String
    let date = Date().timeIntervalSince1970
}
