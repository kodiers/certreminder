//
//  CalendarCertfifcationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 03/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCertfifcationVC: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userCertifications: [UserCertification]?
    var selectedDate: Date?
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        configureCalendarView()
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
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "01-01-2017")!
        let endDate = formatter.date(from: "31-12-2025")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CertificationCalendarCell", for: indexPath) as! CertificationCalendarCell
        if userCertifications != nil {
            if let cellExpCerts = UserCertification.getCertificationByExpirationDate(userCerts: userCertifications!, date: date) {
                cell.configureCell(certs: cellExpCerts)
            }
        }
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        if userCertifications != nil {
            if UserCertification.getCertificationByExpirationDate(userCerts: userCertifications!, date: date) != nil {
                self.selectedDate = date
                tableView.isHidden = false
                tableView.reloadData()
            }
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        tableView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        configureVisibleDates(visibleDates: visibleDates)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarInfoTableCell") as? CalendarInfoTableCell {
            if selectedDate != nil && userCertifications != nil {
                if let certs = UserCertification.getCertificationByExpirationDate(userCerts: userCertifications!, date: selectedDate!) {
                    let userCert = certs[indexPath.row]
                    cell.configureCell(userCert: userCert)
                    return cell
                }
            }
        }
        return CalendarInfoTableCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedDate != nil && userCertifications != nil {
            if let certs = UserCertification.getCertificationByExpirationDate(userCerts: userCertifications!, date: selectedDate!) {
                return certs.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if let userCerts = userCertifications {
                let userCert = userCerts[indexPath.row]
                WebRequestService.webservice.deleteUserCertification(userCertId: userCert.id, completionHandler: {(response, error) in
                    if error != nil {
                        AlertService.showHttpAlert(header: "HTTP Error", message: "Can't delete certification from server", viewController: self)
                    } else {
                        self.userCertifications?.remove(at: indexPath.row)
                        if (UserCertification.getCertificationByExpirationDate(userCerts: self.userCertifications!, date: self.selectedDate!) == nil) {
                            self.tableView.isHidden = true
                        }
                        self.calendarView.reloadData()
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: send data to detail segue
        performSegue(withIdentifier: "CalcCertificationDetailVC", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates({visibleDates in
            self.configureVisibleDates(visibleDates: visibleDates)
        })
        let date = Date()
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month], from: date)
        let startOfCurrentMonth = cal.date(from: components)
        calendarView.scrollToDate(startOfCurrentMonth!)
    }
    
    func configureVisibleDates(visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CertificationCalendarCell else {
            return
        }
        if cellState.dateBelongsTo != .thisMonth {
            validCell.dateLabel.textColor = UIColor.gray
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CertificationCalendarCell else {
            return
        }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }

}
