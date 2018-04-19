//
//  ChooseExamTableCell.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 26/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ChooseExamTableCell: UITableViewCell {

    @IBOutlet weak var examLabel: UILabel!
    var exam: Exam!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(exam: Exam) {
        self.exam = exam
        if let number = exam.number {
            examLabel.text = "\(number) \(exam.title)"
        } else {
            examLabel.text = exam.title
        }
    }

}
