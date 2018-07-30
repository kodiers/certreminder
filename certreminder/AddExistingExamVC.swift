//
//  AddExistingExamVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 28/06/2018.
//  Copyright © 2018 Viktor Yamchinov. All rights reserved.
//

import UIKit

class AddExistingExamVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var addExamBtn: RoundedBorderButton!
    @IBOutlet weak var certificationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var exams = [Exam]()
    var selectedExam: Exam?
    var examService: ExamServiceProtocol = ExamService.instance
    var vendorService: VendorServiceProtocol = VendorService.instance
    
    var certification: Certification!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        certificationLbl.text = certification.title
        downloadExams()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.downloadExams()
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
        return exams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exam = exams[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingExamCell") as? ExistingTableCell {
            cell.configureCell(exam: exam)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExam = exams[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedExam = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewExamSegue" {
            if let vendor = vendorService.getVendorByID(id: certification.vendor), let destination = segue.destination as? NewExamVC {
                destination.vendor = vendor
                destination.certification = certification
            }
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newExamBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "NewExamSegue", sender: self)
    }
    
    @IBAction func addExistingBtnPressed(_ sender: Any) {
        if let exam = selectedExam {
            examService.addCertificationToExam(exam: exam, certification: certification) { (exam, error) in
                if error != nil {
                    AlertService.showCancelAlert(header: "HTTP Error", message: "Could not add exam to certification", viewController: self)
                } else {
                    AlertService.showSuccessAlert(title: "Successfully added", message: "Exam was successfully added to certification", viewController: self)
                }
            }
        }
    }
    
    func downloadExams() {
        // Download exams when view will shown
        showSpinner(spinner: spinner)
        examService.getExamsForCertificationVendor(certification: certification, completionHandler: {(exams, error) in
            self.hideSpinner(spinner: self.spinner)
            if error != nil {
                AlertService.showCancelAlert(header: "HTTP Error", message: "Could not download exams", viewController: self)
            } else {
                if let exms = exams {
                    self.exams = exms
                    self.tableView.reloadData()
                }
            }
        })
    }
}
