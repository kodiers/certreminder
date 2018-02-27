//
//  LoginVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 18/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginField.delegate = self
        passwordField.delegate = self
        
        let token = KeychainWrapper.standard.string(forKey: KEY_UID)
        if token != nil {
            UserService.instance.verifyToken(completionHandler: {(response, error) in
                if error != nil {
                    UserService.instance.refreshToken(completionHandler: {(response, error) in
                        if error != nil {
                            AlertService.showCancelAlert(header: "HTTP Error", message: "Error while refresh token", viewController: self)
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

    @IBAction func loginBtnTapped(_ sender: UIButton) {
        let loginTxt = checkField(field: loginField, header: "Login is empty", message: "Login cannot be blank")
        let passwordTxt = checkField(field: passwordField, header: "Password is empty", message: "Password cannot be blank")
        
        guard let login = loginTxt, let password = passwordTxt else {
            return
        }
        
        UserService.instance.loginUser(username: login, password: password, completionHandler: {(response, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "Incorrect credentials", message: "Login or password incorrect", viewController: self)
            } else {
                self.performSegue(withIdentifier: "LoginShowMainVC", sender: nil)
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

