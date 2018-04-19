//
//  CertificationProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 28/03/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation

protocol CertificationProtocol {
    /*
     Protocol to implement method to manipulate certifications
    */
    func getCertificationById(id: Int) -> Certification?
}
