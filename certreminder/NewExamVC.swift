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
    @IBOutlet weak var saveBtn: RoundedBorderButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var certification: Certification!
    var vendor: Vendor!
    
    var examService: ExamServiceProtocol = ExamService.instance
    
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
        showSpinner(spinner: spinner)
        examService.createExam(title: examTitle, certification: certification, number: examNumberTextFld.text, completionHandler: {(exam, error) in
            self.hideSpinner(spinner: self.spinner)
            if error != nil {
                if (error! as NSError).code == ERROR_CODE_EXAM_EXISTS {
                    AlertService.showCancelAlert(header: "Exam exists", message: "Exam with this title already exists!", viewController: self)
                } else {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Could not create exam", viewController: self)
                }
            } else {
                let alert = UIAlertController(title: "Successfully created", message: "Exam successfully created!", preferredStyle: UIAlertController.Style.alert)
                let presentingVC = self.presentingViewController
                let successAction = UIAlertAction(title: "OK!", style: .default, handler: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: {
                        if let presVC = presentingVC {
                            presVC.dismiss(animated: true, completion: nil)
                        }
                    })
                })
                alert.addAction(successAction)
                self.present(alert, animated: true, completion: nil)
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
        switch result.height {
            case ..<667:
                // less size then iPhone 6
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 150, width: self.view.frame.size.width, height: self.view.frame.size.height)
            case 667:
                // iPhone 6
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 75, width: self.view.frame.size.width, height: self.view.frame.size.height)
            case 736...812:
                // iPhone 6+/iPhone X
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 25, width: self.view.frame.size.width, height: self.view.frame.size.height)
            default:
                break
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let result = UIScreen.main.bounds.size;
        switch result.height {
            case ..<667:
                // less size then iPhone 6
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 150, width: self.view.frame.size.width, height: self.view.frame.size.height)
            case 667:
                // iPhone 6
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 75, width: self.view.frame.size.width, height: self.view.frame.size.height)
            case 736...812:
                // iPhone 6+/iPhone X
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 25, width: self.view.frame.size.width, height: self.view.frame.size.height)
            default:
                break
        }
        return true
    }
}
