//
//  LoginVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 18/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let token = KeychainWrapper.standard.string(forKey: KEY_UID)
        if token != nil {
            WebRequestService.webservice.verifyToken(completionHandler: {(response, error) in
                if error != nil {
                    WebRequestService.webservice.refreshToken(completionHandler: {(response, error) in
                        if error != nil {
                            self.errorLbl.isHidden = false
                            self.errorLbl.text = "Some error then access server"
                        } else {
                            self.performSegue(withIdentifier: "LoginShowMainVC", sender: nil)
                        }
                    })
                } else {
                    self.performSegue(withIdentifier: "LoginShowMainVC", sender: nil)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "RegistrationVC", sender: self)
    }

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        guard let login = loginField.text, login != "" else {
            errorLbl.isHidden = false
            errorLbl.text = "You should enter login"
            return
        }
        
        guard let password = passwordField.text, password != "" else {
            errorLbl.isHidden = false
            errorLbl.text = "You should enter password"
            return
        }
        
        WebRequestService.webservice.loginUser(username: login, password: password, completionHandler: {(response, error) in
            if error != nil {
                self.errorLbl.isHidden = false
                self.errorLbl.text = "Incorrect login or password"
            } else {
                self.performSegue(withIdentifier: "LoginShowMainVC", sender: nil)
            }
        })
    }
}

