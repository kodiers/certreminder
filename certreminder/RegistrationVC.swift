//
//  RegistrationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 22/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

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
        WebRequestService.webservice.registerUser(username: login, password: password, confirm_password: passwordConfirmation)
        if WebRequestService.webservice.user != nil {
            performSegue(withIdentifier: "RegShowMainVC", sender: nil)
        }
    }
}
