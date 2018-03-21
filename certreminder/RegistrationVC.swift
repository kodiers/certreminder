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

class RegistrationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
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
        let loginTxt = checkField(field: loginField, header: "Login is empty", message: "Login cannot be blank")
        let passwordTxt = checkField(field: passwordField, header: "Password is empty", message: "Password cannot be blank")
        let passwordConfirmationTxt = checkField(field: confirmPasswordField, header: "Password confirmation is empty", message: "Password confirmation cannot be blank")
        
        guard let login = loginTxt, let password = passwordTxt, let passwordConfirmation = passwordConfirmationTxt else {
            return
        }

        if password != passwordConfirmation {
            AlertService.showCancelAlert(header: "Password and confirmation should be same", message: "Password and password confirmation should be same", viewController: self)
            return
        }
        // Register and login new user
        UserService.instance.registerUser(username: login, password: password, confirm_password: passwordConfirmation, completionHandler: {(value, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Error then register new user", viewController: self)
            } else {
                // Login registered user
                UserService.instance.loginUser(username: login, password: password, completionHandler: {(value, error) in
                    if error != nil {
                        AlertService.showCancelAlert(header: "HTTP Error", message: "Error then try login new user", viewController: self)
                    } else {
                        self.performSegue(withIdentifier: "RegShowMainVC", sender: nil)
                    }
                })
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
