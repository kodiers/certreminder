//
//  WebRequestService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 23/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire

class WebRequestService {
    static let WEB_API_URL = "http://certapp.techforline.com/api/"
    static let webservice = WebRequestService()
    
    func getRequest(url: String, data: Dictionary<String, AnyObject>, completion: @escaping (Dictionary<String, AnyObject>?) -> ()) {
        let queryUrl = URL(string: WebRequestService.WEB_API_URL + url)
        var responseDict = Dictionary<String, AnyObject>()
        Alamofire.request(queryUrl!).responseJSON {(response) in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                responseDict = dict
            }
            completion(responseDict)
        }
    }
    
}
