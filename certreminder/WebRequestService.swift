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

class WebRequestService {
    /*
     Web request service
    */
    
    // TODO Rewrite this service
    
    static let WEB_API_URL = "http://certapp.techforline.com/api/"
    static let webservice = WebRequestService()
    
    private var _responseDict: Dictionary<String, AnyObject>!
    private var _error: Error!
    private var _user: User?
    private var _token: String?
    
    var user: User? {
        return self._user
    }
    
    var token: String {
        if self._token == nil {
            return ""
        }
        return self._token!
    }
    
    func createHeaders() -> Dictionary<String, String> {
        var headers = ["Accept": "application/json"]
        if self._user == nil {
            if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
                headers = ["Authorization": "Token \(token)"]
            }
        } else {
            headers = ["Authorization": "Token \(self._user!.token)"]
        }
        return headers
    }
    
    func sendRequest(url: String, data: Dictionary<String, AnyObject>, method: HTTPMethod ,completion: @escaping () -> ()) {
        // Handle get requests
        let queryUrl = URL(string: WebRequestService.WEB_API_URL + url)
        let headers = createHeaders()
        Alamofire.request(queryUrl!, method: method, headers: headers).responseJSON {(response) in
            let result = response.result
            if result.isSuccess {
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    self._responseDict = dict
                }
            } else {
                self._error = result.error
            }
            completion()
        }
    }
    
    func registerUser(username: String, password: String, confirm_password: String) {
        // handle register user requests
        let data = ["username": username, "password": password, "confirm_password": confirm_password]
        sendRequest(url: "people/register/", data: data as Dictionary<String, AnyObject>, method: .post, completion: {
            if self._error == nil {
                if let dict = self._responseDict {
                    if let userDict = dict["user"] as? Dictionary<String, AnyObject> {
                        let _ = KeychainWrapper.standard.set(dict["token"] as! String, forKey: KEY_UID)
                        let token = dict["token"] as! String
                        self._token = token
                        let user = User(id: userDict["id"] as! Int, username: userDict["username"] as! String, token: token)
                        self._user = user
                    }
                }
            }
        })
    }
    
    func loginUser(username: String, password: String) {
        let data = ["username": username, "password": password]
        sendRequest(url: "api-token-auth/", data: data as Dictionary<String, AnyObject>, method: .post, completion: {
            if self._error == nil {
                if let dict = self._responseDict {
                    let token = dict["token"] as! String
                    let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                    if self._user != nil {
                        self._user?.token = token
                    }
                    self._token = token
                }
            }
        })
    }
    
}
