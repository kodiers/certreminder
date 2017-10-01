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
    
    private var _user: User?
    private var _token: String?
    
    var user: User? {
        set {
            self._user = newValue
        }
        get {
            return self._user
        }
    }
    
    var token: String? {
        get {
            if self._token == nil {
                return ""
            }
            return self._token!
        }
        set {
            self._token = newValue
            if self._user != nil {
                self._user?.token = newValue
            }
        }
    }
    
    func createHeaders() -> Dictionary<String, String> {
        // Create headers
        var headers = ["Accept": "application/json"]
        if self._user == nil {
            if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
                headers = ["Authorization": "Token \(token)"]
            }
        } else {
            if let token = self._user?.token {
                headers = ["Authorization": "Token \(token)"]
            }
        }
        return headers
    }
    
    func registerUser(username: String, password: String, confirm_password: String, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // handle register user requests
        let data: Parameters = ["username": username, "password": password, "confirm_password": confirm_password]
        let headers = self.createHeaders()
        let url = WebRequestService.WEB_API_URL + "people/register/"
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let userDict = dict["user"] as? Dictionary<String, AnyObject> {
                        let user = User(id: userDict["id"] as! Int, username: userDict["username"] as! String)
                        WebRequestService.webservice.user = user
                        completionHandler(result.value as AnyObject, nil)
                    }
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
        }
    }
    
    func loginUser(username: String, password: String, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Login user function
        let data: Parameters = ["username": username, "password": password]
        let headers = self.createHeaders()
        let url = WebRequestService.WEB_API_URL + "people/api-token-auth/"
        Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON {response in
            let result = response.result
            if result.isSuccess {
                if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                    let token = tokenDict["token"] as! String
                    let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                    WebRequestService.webservice.token = token
                    completionHandler(result.value as AnyObject, nil)
                }
            } else {
                print(result.error!)
                completionHandler(nil, result.error! as NSError)
            }
            
        }
    }
    
    func logoutUser() {
        // Delete stored user credintial and data
        if self.user != nil {
            self.user = nil
            self.user?.token = nil
        }
        if self._token != nil {
            self._token = nil
        }
        let _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
    }
    
    func refreshToken(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Refresh token function
        let headers = ["Accept": "application/json"]
        let url = WebRequestService.WEB_API_URL + "people/api-token-refresh/"
        if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
            let data: Parameters = ["token": token]
            Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
                let result = response.result
                if result.isSuccess {
                    if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                        let token = tokenDict["token"] as! String
                        let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                        WebRequestService.webservice.token = token
                        completionHandler(result.value as AnyObject, nil)
                    }
                } else {
                    print(result.error!)
                    completionHandler(nil, result.error! as NSError)
                }
            }
        } else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token does not exist in keychain"])
            completionHandler(nil, error)
        }
    }
    
    func verifyToken(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Verify token function
        let headers = ["Accept": "application/json"]
        let url = WebRequestService.WEB_API_URL + "people/api-token-verify/"
        if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
            let data: Parameters = ["token": token]
            Alamofire.request(url, method: .post, parameters: data, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
                let result = response.result
                if result.isSuccess {
                    if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                        let token = tokenDict["token"] as! String
                        let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                        WebRequestService.webservice.token = token
                        completionHandler(result.value as AnyObject, nil)
                    }
                } else {
                    // if error try refresh token
                    self.refreshToken(completionHandler: {(value, error) in
                        if error != nil {
                            // if error logut user
                            self.logoutUser()
                            print(result.error!)
                            completionHandler(nil, result.error! as NSError)
                        } else {
                            completionHandler(value, nil)
                        }
                    })
                }
            }
        }

    }
    
}
