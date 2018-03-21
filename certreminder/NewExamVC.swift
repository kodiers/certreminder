//
//  NewExamVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 30/01/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

class NewExamVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var vendorLbl: UILabel!
    @IBOutlet weak var certificationLbl: UILabel!
    @IBOutlet weak var examNumberTextFld: UITextField!
    @IBOutlet weak var examTitleTextFld: UITextField!
    
    var certification: Certification!
    var vendor: Vendor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vendorLbl.text = vendor.title
        certificationLbl.text = certification.title
        examNumberTextFld.delegate = self
        examTitleTextFld.delegate = self

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
        guard let examTitle = examTitleTextFld.text, examTitle != "" else {
            AlertService.showCancelAlert(header: "You should enter exam name", message: "Exam name cannot be blank", viewController: self)
            return
        }
        ExamService.instance.createExam(title: examTitle, certification: certification, number: examNumberTextFld.text, completionHandler: {(exam, error) in
            if error != nil {
                if (error! as NSError).code == ERROR_CODE_EXAM_EXISTS {
                    AlertService.showCancelAlert(header: "Exam exists", message: "Exam with this title already exists!", viewController: self)
                } else {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Could not create exam", viewController: self)
                }
            } else {
                AlertService.showSuccessCreateAlert(message: "Exam successfully created!", viewController: self)
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
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 150, width: self.view.frame.size.width, height: self.view.frame.size.height)
        } else if (result.height == 667) {
            // iPhone 6
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 75, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let result = UIScreen.main.bounds.size;
        if (result.height < 667)
        {
            // less size then iPhone 6
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 150, width: self.view.frame.size.width, height: self.view.frame.size.height)
        } else if (result.height == 667) {
            // iPhone 6
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 75, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        return true
    }
}
