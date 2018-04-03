//
//  AddExamsVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class AddExamsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var certification: Certification!
    var exams = [Exam]()
    var selectedExam: Exam?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        self.downloadExams()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseExamTableCell") as? ChooseExamTableCell {
            cell.configureCell(exam: exam)
            return cell
        }
        return ChooseExamTableCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExam = exams[indexPath.row]
        performSegue(withIdentifier: "ChooseExamDateVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseExamDateVC" {
            if let destination = segue.destination as? ChooseExamDateVC {
                if let exam = selectedExam {
                    destination.exam = exam
                }
            }
        }
        if segue.identifier == "NewExamSegue" {
            if let destination = segue.destination as? NewExamVC {
                destination.certification = certification
                if let vendor = VendorService.instance.getVendorByID(id: certification.vendor) {
                    destination.vendor = vendor
                }
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "NewExamSegue", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func downloadExams() {
        // Download exams when view will shown
        ExamService.instance.getExams(certification: certification, completionHandler: {(exams, error) in
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
