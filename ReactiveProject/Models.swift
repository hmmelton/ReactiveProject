//
//  Models.swift
//  ReactiveProject
//
//  Created by Harrison Melton on 8/16/17.
//  Copyright © 2017 Harrison Melton. All rights reserved.
//

import Foundation

struct User {
    var id: Int
    var name: String
    var username: String
    var email: String
}

struct Album {
    var userId: Int
    var id: Int
    var title: String
}
