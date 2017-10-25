//
//  ColoredPickerView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 26/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ColoredPickerView: UIPickerView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        // TODO: Debug this
        for v in subviews {
            if let label = v as? UILabel {
                label.textColor = UIColor(red: 219.0 / 255.0, green: 223.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
            }
        }
    }

}
