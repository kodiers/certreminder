//
//  File.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 06/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol UserCertificationServiceProtocol {
    /*
     Protocol for UserCertificationService
    */
    func getUserCertification(completionHandler: @escaping RequestComplete)
    
    func deleteUserCertification(userCertId: Int, completionHandler: @escaping RequestComplete)
}
