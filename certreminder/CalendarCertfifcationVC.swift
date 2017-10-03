//
//  CalendarCertfifcationVC.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 03/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCertfifcationVC: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self

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
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "01 01 2017")!
        let endDate = formatter.date(from: "31 12 2017")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CertificationCalendarCell", for: indexPath) as! CertificationCalendarCell
        cell.dateLabel.text = cellState.text
        return cell
    }

}
