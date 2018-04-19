//
//  ChooseDateVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 24/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseDateVC: UIViewController {

    @IBOutlet weak var datePicker: ColoredDatePicker!
    
    var choosedDate: Date?
    private let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let date = choosedDate {
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
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        // Set datepicker date to addcertificationvc.dateLabel
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        choosedDate = datePicker.date
        if let date = choosedDate {
            let dateStr = formatter.string(from: date)
            if let destination = self.presentingViewController as? AddCertificationVC {
                destination.dateLabel.text = dateStr
                destination.certificationExpireDate = date
            }
            if let destination = self.presentingViewController as? CertificationDetailVC {
                destination.userCerification.expirationDate = date
                destination.dateLabel.text = dateStr
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
