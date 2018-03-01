//
//  WebRequestService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 23/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftKeychainWrapper

typealias RequestComplete = () -> ()

class WebRequestService {
    /*
     Web request service
    */

    
    static let WEB_API_URL = "http://certapp.techforline.com/api/"
    static let webservice = WebRequestService()
    
    private let formatter = DateFormatter()
    
    func createHeaders() -> Dictionary<String, String> {
        // Create headers
        var headers = ["Accept": "application/json", "Content-Type": "application/json"]
        if let token = UserService.instance.token {
            headers["Authorization"] = "Token \(token)"
        }
        return headers
    }
    
    func post(url: String, params: Parameters, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send post request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url
        Alamofire.request(fullUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(result.value as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func get(url: String, data: Parameters?, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send get request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url
        Alamofire.request(fullUrl, method: .get, parameters: data, encoding: URLEncoding.queryString, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(result.value as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func delete(url: String, objectID: Int, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send delete request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url + "\(objectID)/"
        Alamofire.request(fullUrl, method: .delete, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                // Return if deletion success, because no content
                completionHandler(true as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func patch(url: String, data: Parameters, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Send patch request
        let headers = self.createHeaders()
        let fullUrl = WebRequestService.WEB_API_URL + url
        Alamofire.request(fullUrl, method: .patch, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                completionHandler(result.value as AnyObject, nil)
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
}
