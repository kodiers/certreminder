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
    var userExam: UserExam?  // Used whe change date for exam
    
    var choosedDataService: ChoosedDataServiceProtocol = ChoosedDataService.instance
    
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
        if let userEx = userExam {
            datePicker.setDate(userEx.dateOfPass, animated: false)
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
                if let ewd = choosedDataService.examsWithDate {
                    destination.examsWithDate = ewd
                }
                if let date = examDate, let exm = exam {
                    let examWithDate = (exm, date)
                    if let examIndex = choosedDataService.getIndexInExamsWithDateFor(exam: exm) {
                        destination.examsWithDate[examIndex].1 = date
                    } else {
                        destination.examsWithDate.append(examWithDate)
                    }
                }
                
            }
        }
        if segue.identifier == "BackToDetailVC" {
            if let destination = segue.destination as? CertificationDetailVC {
                if let uExame = userExam {
                    if let date = examDate {
                        uExame.dateOfPass = date
                    }
                    choosedDataService.changeUserExam(userExam: uExame)
                    prepareToDetailVC(destination: destination)
                } else {
                    if let date = examDate {
                        if let userCert = choosedDataService.userCertification {
                            let userExam = UserExam(id: NEW_OBJECT_ID, userCertId: userCert.id, exam: exam, dateOfPass: date)
                            prepareToDetailVC(destination: destination)
                            if let exmIndex = choosedDataService.getIndexInUsersExam(exam: exam) {
                                destination.usersExams[exmIndex].dateOfPass = date
                            } else {
                                destination.usersExams.append(userExam)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        examDate = datePicker.date
        if choosedDataService.isEditExistingUserCertification {
            choosedDataService.isEditExistingUserCertification = false
            performSegue(withIdentifier: "BackToDetailVC", sender: nil)
        } else {
            choosedDataService.isEditExistingUserCertification = false
            performSegue(withIdentifier: "AddCertificationExamChoosed", sender: nil)
        }
    }
    
    func prepareToDetailVC(destination: CertificationDetailVC) {
        if let userExams = choosedDataService.userExams {
            destination.usersExams = userExams
        }
        if let userCert = choosedDataService.userCertification {
            destination.userCerification = userCert
        }
    }
}
