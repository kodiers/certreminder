//
//  RegistrationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 22/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper

class RegistrationVC: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        guard let login = loginField.text, login != "" else {
            errorLbl.isHidden = false
            errorLbl.text = "You should enter login"
            return
        }
        guard let password = passwordField.text, password != "" else {
            errorLbl.isHidden = false
            errorLbl.text = "You should enter your password"
            return
        }
        guard let passwordConfirmation = confirmPasswordField.text, passwordConfirmation != "" else {
            errorLbl.isHidden = false
            errorLbl.text = "You should confirm your password"
            return
        }
        if password != passwordConfirmation {
            errorLbl.isHidden = false
            errorLbl.text = "Password and confirmation shoul be same"
            return
        }
        // Register and login new user
        let registerUrl = "\(WebRequestService.WEB_API_URL)people/register/"
        let headers = WebRequestService.webservice.createHeaders()
        let registerData: Parameters = ["username": login, "password": password, "confirm_password": passwordConfirmation]
        Alamofire.request(registerUrl, method: .post, parameters: registerData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) in
            let result = response.result
            if result.isSuccess {
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let userDict = dict["user"] as? Dictionary<String, AnyObject> {
                        let user = User(id: userDict["id"] as! Int, username: userDict["username"] as! String)
                        WebRequestService.webservice.user = user
                        let loginUrl = "\(WebRequestService.WEB_API_URL)people/api-token-auth/"
                        let loginData: Parameters = ["username": login, "password": password]
                        // TODO: place login request in WebRequestService
                        Alamofire.request(loginUrl, method: .post, parameters: loginData, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {(response) in
                            let result = response.result
                            if result.isSuccess {
                                if let tokenDict = result.value as? Dictionary<String, AnyObject> {
                                    let token = tokenDict["token"] as! String
                                    let _ = KeychainWrapper.standard.set(token, forKey: KEY_UID)
                                    WebRequestService.webservice.token = token
                                    self.performSegue(withIdentifier: "RegShowMainVC", sender: nil)
                                }
                            } else {
                                print(result.error!)
                                self.errorLbl.text = "Error then try login new user"
                            }
                        })
                    }
                }
            } else {
                print(result.error!)
                self.errorLbl.text = "Error then register new user"
            }
        })
    }
}
