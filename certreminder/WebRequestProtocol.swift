//
//  WebRequestProtocol.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 29/03/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

protocol WebRequestProtocol {
    /*
    Protocol to implement http request method
    */
    
    func post(url: String, params: Parameters, completionHandler: @escaping RequestComplete)
    
    func get(url: String, data: Parameters?, completionHandler: @escaping RequestComplete)
    
    func delete(url: String, objectID: Int, completionHandler: @escaping RequestComplete)
    
    func patch(url: String, data: Parameters, completionHandler: @escaping RequestComplete)
}
