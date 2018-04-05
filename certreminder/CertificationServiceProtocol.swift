//
//  CertificationServiceProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 06/04/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol CertificationServiceProtocol {
    /*
     Protocol for CertificationService
    */
    func downloadCertifications(vendor: Vendor?, completionHandler: @escaping ([Certification]?, NSError?) -> ())
}
