//
//  Note.swift
//  ToDoList
//
//  Created by Hossam on 10/2/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation

struct note: Codable {
    var id: String? = nil
    var date: String
    var content: String
}
