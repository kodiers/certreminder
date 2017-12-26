//
//  CertificationDetailVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 17/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CertificationDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var certificationTitleLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var examTableView: UITableView!
    
    private var formatter = DateFormatter()
    
    var userCerification: UserCertification!
    var vendor: Vendor?
    var usersExams = [UserExam]()
    var examForEdit: UserExam?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        examTableView.delegate = self
        examTableView.dataSource = self
        configureVC()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureVC()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersExams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userExam = usersExams[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosedExamsWithDateTableViewCellDetail") as? ChoosedExamsWithDateTableViewCell {
            cell.configureCell(exam: userExam.exam, date: userExam.dateOfPass)
            return cell
        }
        return ChoosedExamsWithDateTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let userExam = usersExams[indexPath.row]
            if userExam.id != NEW_OBJECT_ID {
                WebRequestService.webservice.deleteUserExam(userExamId: userExam.id, completionHandler: {(result, error) in
                    if error != nil {
                        AlertService.showCancelAlert(header: "HTTP Error", message: "Error then deleting exam", viewController: self)
                    } else {
                        self.deleteUserExam(index: indexPath.row)
                    }
                })
            } else {
                deleteUserExam(index: indexPath.row)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseCertDateDetail" {
            if let destination = segue.destination as? ChooseDateVC {
                destination.choosedDate = userCerification.expirationDate
            }
        }
        if segue.identifier == "AddExamDetailVC" {
            if let destination = segue.destination as? AddExamsVC {
                destination.certification = userCerification.certification
                ChoosedDataService.instance.saveEditData(isEdit: true, userCert: userCerification, userExams: usersExams)
            }
        }
        if segue.identifier == "ChooseExamDateDetailVC" {
            if let destination = segue.destination as? ChooseExamDateVC {
                if let exam = examForEdit {
                    destination.exam = exam.exam
                    destination.userExam = examForEdit
                    ChoosedDataService.instance.saveEditData(isEdit: true, userCert: userCerification, userExams: usersExams)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        examForEdit = usersExams[indexPath.row]
        performSegue(withIdentifier: "ChooseExamDateDetailVC", sender: self)
    }
    
    @IBAction func addExamButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "AddExamDetailVC", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "BackToCertListFromDetail", sender: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
    }
    
    func configureVC() {
        certificationTitleLabel.text = userCerification.certification.title
        if let vendors = VendorService.instance.vendors {
            vendor = Vendor.getVendorById(id: userCerification.certification.vendor, vendors: vendors)
            if let ven = vendor {
                vendorLabel.text = ven.title
            } else {
                vendorLabel.text = "N/A"
                AlertService.showCancelAlert(header: "Vendor not found", message: "Vendor not found in database", viewController: self)
            }
        } else {
            vendorLabel.text = "N/A"
            AlertService.showCancelAlert(header: "Vendor not found", message: "Vendor not found in database", viewController: self)
        }
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: userCerification.expirationDate)
        dateLabel.text = dateStr
        if usersExams.count == 0 {
            WebRequestService.webservice.getUserExamsForCertification(certification: userCerification, completionHandler: {(exams, error) in
                if error != nil {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Could not download user's exams", viewController: self)
                } else {
                    self.usersExams = exams as! [UserExam]
                }
            })
        }
        examTableView.reloadData()
    }
    
    func deleteUserExam(index: Int) {
        // Helper function for delete user exam from array
        usersExams.remove(at: index)
        examTableView.reloadData()
    }
    
}
