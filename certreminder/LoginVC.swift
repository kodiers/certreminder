//
//  LoginVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 18/08/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // TODO: Add register stack view bottom margin

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "RegistrationVC", sender: self)
    }

}

