//
//  UserService.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 09/02/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import Alamofire

class UserService {
    /*
     User service
    */
    
    static let instance = UserService()
    
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
                if let token = KeychainWrapper.standard.string(forKey: KEY_UID) {
                    return token
                }
                return nil
            }
            return self._token!
        }
        set {
            self._token = newValue
            if let token = newValue {
                let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
            }
            if self._user != nil {
                self._user?.token = newValue
            }
        }
    }
    
    func registerUser(username: String, password: String, confirm_password: String, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // handle register user requests
        self.logoutUser()
        let data: Parameters = ["username": username, "password": password, "confirm_password": confirm_password]
        let url = "people/register/"
        WebRequestService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let dict = result as? Dictionary<String, AnyObject> {
                    if let userDict = dict["user"] as? Dictionary<String, AnyObject> {
                        let user = User(id: userDict["id"] as! Int, username: userDict["username"] as! String)
                        self.user = user
                        completionHandler(result as AnyObject, nil)
                    }
                }
            }
        })
    }
    
    func loginUser(username: String, password: String, completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Login user function
        let data: Parameters = ["username": username, "password": password]
        let url = "people/api-token-auth/"
        WebRequestService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil, error)
            } else {
                if let tokenDict = result as? Dictionary<String, AnyObject> {
                    if let token = tokenDict["token"] as? String {
                        self.token = token
                        completionHandler(result as AnyObject, nil)
                    } else {
                        let error = NSError(domain: CUSTOM_ERROR_DOMAIN, code: ERROR_CODE_LOGIN, userInfo: [NSLocalizedDescriptionKey: "Could not login"])
                        completionHandler(nil, error)
                    }
                }
            }
        })
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
        let url = "people/api-token-refresh/"
        if let tkn = self.token {
            let data: Parameters = ["token": tkn]
            WebRequestService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
                if error != nil {
                    completionHandler(nil, error)
                } else {
                    if let tokenDict = result as? Dictionary<String, AnyObject> {
                        if let token = tokenDict["token"] as? String {
                            self.token = token
                            completionHandler(result as AnyObject, nil)
                        } else {
                            print("Could not refresh token \(tokenDict)")
                            let err = NSError(domain: CUSTOM_ERROR_DOMAIN, code: ERROR_CODE_HTTP_ERROR, userInfo: [NSLocalizedDescriptionKey: "Could not refresh token"])
                            completionHandler(nil, err)
                        }
                    }
                }
            })
        } else {
            let error = NSError(domain: CUSTOM_ERROR_DOMAIN, code: ERROR_CODE_HTTP_ERROR, userInfo: [NSLocalizedDescriptionKey: "Token does not exist in keychain"])
            completionHandler(nil, error)
        }
    }
    
    func verifyToken(completionHandler: @escaping (AnyObject?, NSError?) -> ()) {
        // Verify token function
        let url = "people/api-token-verify/"
        if let tkn = self.token {
            let data: Parameters = ["token": tkn]
            WebRequestService.webservice.post(url: url, params: data, completionHandler: {(result, error) in
                if let tokenDict = result as? Dictionary<String, AnyObject> {
                    if let token = tokenDict["token"] as? String {
                        self.token = token
                        completionHandler(result as AnyObject, nil)
                    } else {
                        self.refreshToken(completionHandler: {(value, error) in
                            if error != nil {
                                // if error logut user
                                self.logoutUser()
                                print(error!)
                                completionHandler(nil, error!)
                            } else {
                                completionHandler(value, nil)
                            }
                        })
                    }
                }
            })
        }
    }
}
