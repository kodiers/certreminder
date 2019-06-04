//
//  ReminderLblStackView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 05/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class ReminderLblStackView: UIStackView {

    /*
     UIStackView contains 2 text labels (Logo of app)
    */
    
    private(set) lazy var reLbl: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 32)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8588235294, green: 0.8745098039, blue: 0.4470588235, alpha: 1)]
        label.attributedText = NSAttributedString(string: "Re:", attributes: attributes)
        label.preservesSuperviewLayoutMargins = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var minderLbl: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 32)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8235294118, green: 0.6745098039, blue: 0.8235294118, alpha: 1)]
        label.attributedText = NSAttributedString(string: "Minder", attributes: attributes)
        label.preservesSuperviewLayoutMargins = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        // Appearance customization
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 1
        self.autoresizesSubviews = true
        self.clearsContextBeforeDrawing = true
        self.preservesSuperviewLayoutMargins = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addArrangedSubview(reLbl)
        self.addArrangedSubview(minderLbl)
    }

}
