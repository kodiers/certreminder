//
//  ChooseExamDateVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 27/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseExamDateVC: UIViewController {

    @IBOutlet weak var examNumberLabel: UILabel!
    @IBOutlet weak var examTitleLabel: UILabel!
    @IBOutlet weak var datePicker: ColoredDatePicker!
    
    var exam: Exam!
    var examDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let num = exam.number {
            examNumberLabel.text = num
        }
        examTitleLabel.text = exam.title
        if let date = examDate {
            datePicker.setDate(date, animated: false)
        }
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

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCertificationExamChoosed" {
            if let destination = segue.destination as? AddCertificationVC {
                destination.vendor = ChoosedDataService.instance.vendor
                destination.choosedCert = ChoosedDataService.instance.choosedCert
                destination.certificationExpireDate = ChoosedDataService.instance.certificationExpireDate
                if let ewd = ChoosedDataService.instance.examsWithDate {
                    destination.examsWithDate = ewd
                }
                if let date = examDate {
                    let examWithDate = (exam!, date)
                    destination.examsWithDate.append(examWithDate)
                }
                
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        examDate = datePicker.date
        performSegue(withIdentifier: "AddCertificationExamChoosed", sender: nil)
    }
}
