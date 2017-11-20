//
//  ChoosedExamsWithDateTableViewCell.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 15/11/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChoosedExamsWithDateTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var examNumberLabel: UILabel!
    @IBOutlet weak var examTitleLabel: UILabel!
    
    private let formatter = DateFormatter()
    
    var exam: Exam?
    var date: Date?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(exam: Exam, date: Date) {
        self.exam = exam
        self.date = date
        if let num = exam.number {
            examNumberLabel.text = num
        }
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let dateStr = formatter.string(from: date)
        dateLabel.text = dateStr
        examTitleLabel.text = exam.title
    }

}
