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
    @IBOutlet weak var loginBtn: RoundedBorderButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var userService: UserServiceProtocol = UserService.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginField.delegate = self
        passwordField.delegate = self
        
        let token = KeychainWrapper.standard.string(forKey: KEY_UID)
        if token != nil {
            showSpinner(spinner: spinner)
            userService.verifyToken(completionHandler: {(response, error) in
                if error != nil {
                    self.userService.refreshToken(completionHandler: {(response, error) in
                        self.hideSpinner(spinner: self.spinner)
                        if error != nil {
                            AlertService.showCancelAlert(header: "You should log in", message: "You should login again.", viewController: self)
                        } else {
                            self.performSegue(withIdentifier: "LoginShowMainVC", sender: nil)
                        }
                    })
                } else {
                    self.hideSpinner(spinner: self.spinner)
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
        showSpinner(spinner: spinner)
        userService.loginUser(username: login, password: password, completionHandler: {(response, error) in
            self.hideSpinner(spinner: self.spinner)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let result = UIScreen.main.bounds.size;
        if (result.height < 667)
        {
            // less size then iPhone 6
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 50, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let result = UIScreen.main.bounds.size;
        if (result.height < 667)
        {
            // less size then iPhone 6
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 50, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        return true
    }
}

