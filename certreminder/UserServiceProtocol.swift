//
//  UserServiceProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 10/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    
    func registerUser(username: String, email: String, password: String, confirm_password: String, completionHandler: @escaping RequestComplete)
    
    func loginUser(username: String, password: String, completionHandler: @escaping RequestComplete)
    
    func refreshToken(completionHandler: @escaping RequestComplete)
    
    func verifyToken(completionHandler: @escaping RequestComplete)
    
    func restorePassword(for email: String, completionHandler: @escaping RequestComplete)
}
