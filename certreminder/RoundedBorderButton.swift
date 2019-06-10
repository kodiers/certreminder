//
//  RoundedBorderButton.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 03/10/2017.
//  Copyright © 2017 Viktor Yamchinov. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedBorderButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    func setupTitleLabel(with text: String, color: UIColor) {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 18)!, NSAttributedString.Key.foregroundColor: color
        ]
        let attributedTitle = NSAttributedString(string: text, attributes: attributes)
        setAttributedTitle(attributedTitle, for: .normal)
        setAttributedTitle(attributedTitle, for: .selected)
    }

}
