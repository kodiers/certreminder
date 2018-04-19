//
//  ChooseCertificationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseCertificationVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var certifications = [Certification]()
    var choosedCert: Certification?
    var vendor: Vendor!
    var certificationService: CertificationServiceProtocol = CertificationService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        self.getCertifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCertifications()
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
        return certifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cert = certifications[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseCertificationTableCellCell") as? ChooseCertificationTableCellCell {
            var choosed = false
            if choosedCert != nil && choosedCert?.id == cert.id {
                choosed = true
            }
            cell.configureCell(cert: cert, isChoosed: choosed)
            return cell
        }
        return ChooseCertificationTableCellCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChooseCertificationTableCellCell {
            let cells = tableView.getAllCells()
            for cl in cells {
                if let c = cl as? ChooseCertificationTableCellCell {
                    c.chooseCell(isChoosed: false)
                }
            }
            choosedCert = certifications[indexPath.row]
            cell.chooseCell(isChoosed: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChooseCertificationTableCellCell {
            choosedCert = nil
            cell.chooseCell(isChoosed: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCertificationSegue" {
            if let destination = segue.destination as? NewCertificationVC {
                destination.vendor = vendor
            }
            
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        if let cert = choosedCert {
            if let destination = self.presentingViewController as? AddCertificationVC {
                destination.choosedCert = cert
                destination.certificationLabel.text = cert.title
                if let choosedCertification = ChoosedDataService.instance.choosedCert {
                    if choosedCertification.id != cert.id {
                        destination.examsWithDate.removeAll()
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func setCertifications(certifications: [Certification]) {
        self.certifications = certifications
        self.tableView.reloadData()
    }
    
    func showAlert(header: String, message: String) {
        // This function need to avoid hierarchy view warning
        AlertService.showCancelAlert(header: header, message: message, viewController: self)
    }
    
    func getCertifications() {
        showSpinner(spinner: spinner)
        // Download certifications from server
        certificationService.downloadCertifications(vendor: vendor, completionHandler: {(certifications, error) in
            self.hideSpinner(spinner: self.spinner)
            if error != nil {
                self.showAlert(header: "HTTP Error", message: "Cannot get certifications from server")
            } else {
                self.setCertifications(certifications: certifications!)
            }
        })
    }
}
