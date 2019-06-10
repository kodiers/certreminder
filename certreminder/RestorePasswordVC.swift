//
//  RestorePasswordVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 04/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class RestorePasswordVC: UIViewController {
    
    /*
     Restore password ViewController
    */
    
    var userService: UserServiceProtocol = UserService.instance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        let view = RestorePasswordView(with: "Restore password")
        view.delegate = self
        view.addActions()
        self.view = view
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}


extension RestorePasswordVC: RestorePasswordDelegate {
    /*
     Implementing method for RestorePasswordDelegate
    */
    @objc func backBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func restorPasswordBtnPressed() {
        guard let view = self.view as? RestorePasswordView else {
            return
        }
        let emailTxt = checkField(field: view.textField, header: "Email is empty", message: "Email cannot be blank.")
        guard let email = emailTxt else { return }
        if !validateEmail(str: email) {
            AlertService.showCancelAlert(header: "Email is invalid", message: "Email is not correct email.", viewController: self)
            return
        }
        self.userService.restorePassword(for: email) { (result, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "Email is invalid.", message: "Could not send email for current email. Error: \(String(describing: error?.description))", viewController: self)
            } else {
                AlertService.showCancelAlert(header: "Email was successfully sent.", message: "Check your email inbox and follow instructions.", viewController: self)
            }
        }
    }
    
    
}
