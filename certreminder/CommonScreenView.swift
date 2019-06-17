//
//  CommonScreenView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 07/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class CommonScreenView: UIView {

    /*
     Common screen view with logo, title and bottom background image
    */
    
    var titleText: String! = "Welcome"
    
    private(set) lazy var cityImageView: CityImageView = CityImageView(frame: .zero)
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 24)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
        label.attributedText = NSAttributedString(string: self.titleText, attributes: attributes)
        label.preservesSuperviewLayoutMargins = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var logoView: ReminderLblStackView = ReminderLblStackView(frame: .zero)
    
    init(with title: String) {
        self.titleText = title
        super.init(frame: .zero)
        self.configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    private func configureView() {
        // Appearance customization
        self.backgroundColor = MAIN_COLOR
        self.addSubviews()
        self.setupConstraints()
    }
    
    private func addSubviews() {
        // Add subviews
        self.addSubview(self.titleLabel)
        self.addSubview(self.logoView)
        self.addSubview(self.cityImageView)
    }
    
    private func setupConstraints() {
        // Setup view constraints
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            self.logoView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.logoView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            
            self.cityImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.cityImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.cityImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.cityImageView.heightAnchor.constraint(equalToConstant: CityImageView.viewHeight)
        ])
    }

}
