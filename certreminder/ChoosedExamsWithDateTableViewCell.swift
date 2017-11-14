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
    
    var exam: Exam?
    var dateStr: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(exam: Exam, dateStr: String) {
        self.exam = exam
        self.dateStr = dateStr
        if let num = exam.number {
            examNumberLabel.text = num
        }
        dateLabel.text = dateStr
        examTitleLabel.text = exam.title
    }

}
