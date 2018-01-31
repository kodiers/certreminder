//
//  NewExamVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 30/01/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

class NewExamVC: UIViewController {

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
        // TODO: Add save exam methods
        guard let examTitle = examTitleTextFld.text, examTitle != "" else {
            AlertService.showCancelAlert(header: "You should enter exam name", message: "Exam name cannot be blank", viewController: self)
            return
        }
        WebRequestService.webservice.createExam(title: examTitle, certification: certification, number: examNumberTextFld.text, completionHandler: {(exam, error) in
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
}
