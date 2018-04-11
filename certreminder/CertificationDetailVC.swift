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
    
    var vendorService: VendorServiceProtocol = VendorService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        examTableView.delegate = self
        examTableView.dataSource = self
        examTableView.estimatedRowHeight = 75
        examTableView.rowHeight = UITableViewAutomaticDimension
        
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
            showExamDeleteAlert(index: indexPath.row)
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
        AlertService.showDeleteAlert(header: "Are you shure want to delete \"\(userCerification.certification.title)\"", message: "This action can not be undone!", viewController: self, handler: {(UIAlertAction) in
            self.deleteUserCertification()
        })
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        UserCertificationService.instance.changeUserCertification(userCert: self.userCerification, completionHandler: {(response, error) in
            if error == nil {
                if !self.usersExams.isEmpty {
                    let examsForCreation = self.getNewUsersExams()
                    let examsForUpdate = self.getExamsForUpdate()
                    if examsForCreation.count > 0 {
                        UserExamService.instance.createUserExams(certification: self.userCerification, examsWithDate: examsForCreation, completionHandler: {(response, error) in
                            if error != nil {
                                AlertService.showCancelAlert(header:  "HTTP Error", message: "Can't add exams", viewController: self)
                            }
                        })
                    }
                    if examsForUpdate.count > 0 {
                        UserExamService.instance.changeUserExams(certification: self.userCerification, userExams: examsForUpdate, completionHandler: {(response, error) in
                            if error != nil {
                                AlertService.showCancelAlert(header:  "HTTP Error", message: "Cannot change exams", viewController: self)
                            }
                        })
                    }
                }
                self.showSuccessUpdateAlert()
            } else {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Could not save certification", viewController: self)
            }
        })
    }
    
    func configureVC() {
        certificationTitleLabel.text = userCerification.certification.title
        if let vendors = vendorService.vendors {
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
            UserExamService.instance.getUserExamsForCertification(certification: userCerification, completionHandler: {(exams, error) in
                if error != nil {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Could not download user's exams", viewController: self)
                } else {
                    if let exms = exams {
                        self.usersExams = exms
                    }
                }
            })
        }
        examTableView.reloadData()
    }
    
    func deleteUserExam(userExam: UserExam, index: Int) {
        // Function to delete userExam
        if userExam.id != NEW_OBJECT_ID {
            UserExamService.instance.deleteUserExam(userExamId: userExam.id, completionHandler: {(result, error) in
                if error != nil {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Error then deleting exam", viewController: self)
                } else {
                    self.deleteUserExamFromArray(index: index)
                }
            })
        } else {
            self.deleteUserExamFromArray(index: index)
        }
    }
    
    func deleteUserExamFromArray(index: Int) {
        // Helper function for delete user exam from array
        usersExams.remove(at: index)
        examTableView.reloadData()
    }
    
    func getNewUsersExams() -> [(Exam, Date)] {
        // Return new exams
        var exams = [(Exam, Date)]()
        for uexam in self.usersExams {
            if uexam.id == NEW_OBJECT_ID {
                exams.append((uexam.exam, uexam.dateOfPass))
            }
        }
        return exams
    }
    
    func getExamsForUpdate() -> [UserExam] {
        // Return exams for update (old exams)
        var exams = [UserExam]()
        for uexam in self.usersExams {
            if uexam.id != NEW_OBJECT_ID {
                exams.append(uexam)
            }
        }
        return exams
    }
    
    func deleteUserCertification() {
        // Send and handle request for delete user certification
        UserCertificationService.instance.deleteUserCertification(userCertId: userCerification.id, completionHandler: {(response, error) in
            if error != nil {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Can't delete certification from server", viewController: self)
            } else {
                self.performSegue(withIdentifier: "BackToCertListFromDetail", sender: nil)
            }
        })
    }
    
    func showSuccessUpdateAlert() {
        // Show success alert and return to certification list after "OK" pressed
        let alert = UIAlertController(title: "Successfully saved", message: "Certification was succesfully saved!", preferredStyle: UIAlertControllerStyle.alert)
        let successAction = UIAlertAction(title: "OK!", style: .default, handler: {(UIAlertAction) in
            self.performSegue(withIdentifier: "BackToCertListFromDetail", sender: nil)
        })
        alert.addAction(successAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showExamDeleteAlert(index: Int) {
        // Show alert and delete userExam after confirmation
        let userExam = usersExams[index]
        let alertStr = "Are you sure want to delete \"\(userExam.exam.title)\"?"
        AlertService.showDeleteAlert(header: alertStr, message: "This action can not be undone!", viewController: self, handler: {(UIAlertAction) in
            self.deleteUserExam(userExam: userExam, index: index)
        })
    }
    
}
