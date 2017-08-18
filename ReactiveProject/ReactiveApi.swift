//
//  ReactiveApi.swift
//  ReactiveProject
//
//  Created by Harrison Melton on 8/17/17.
//  Copyright © 2017 Harrison Melton. All rights reserved.
//

import Foundation
import ReactiveJSON

/*
 * This struct allows for interaction with the JSONPlaceholder API.
 */
struct ReactiveApi: Singleton, ServiceHost {
    // Singleton
    private(set) static var shared = Instance()
    typealias Instance = ReactiveApi
    
    // ServiceHost
    static var scheme: String { return "http" }
    static var host: String { return "jsonplaceholder.typicode.com" }
    static var path: String? { return nil }
}
