//
//  NewCertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 26/01/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

class NewCertificationVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var vendorLbl: UILabel!
    @IBOutlet weak var certificationNameTextFld: UITextField!
    @IBOutlet weak var saveBtn: RoundedBorderButton!
    
    var vendor: Vendor!
    var certService: CertificationServiceProtocol = CertificationService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vendorLbl.text = vendor.title
        certificationNameTextFld.delegate = self
        
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

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        guard let certName = certificationNameTextFld.text, certName != "" else {
            AlertService.showCancelAlert(header: "You should enter certification name", message: "Certification name cannot be blank", viewController: self)
            return
        }
        certService.createCertification(title: certName, vendor: vendor, completionHandler: ({(newCert, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Could not create certification", viewController: self)
            } else {
                AlertService.showSuccessCreateAlert(message: "Certification was succesfully created!", viewController: self)
            }
        }))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        certificationNameTextFld.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
