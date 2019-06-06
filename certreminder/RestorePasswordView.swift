//
//  RestorePasswordView.swift
//  certreminder
//
//  Created by Viktor Yamchinov on 07/06/2019.
//  Copyright © 2019 Viktor Yamchinov. All rights reserved.
//

import UIKit

class RestorePasswordView: CommonScreenView {

    /*
    View for RestorePasswordVC
    */
    
    private(set) lazy var emailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.autoresizesSubviews = true
        stackView.clearsContextBeforeDrawing = true
        stackView.preservesSuperviewLayoutMargins = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var fieldLabel: UILabel = {
        let label = UILabel()
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "Avenir-Book", size: 16)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8235294118, green: 0.6745098039, blue: 0.8235294118, alpha: 1)]
        label.attributedText = NSAttributedString(string: "Email", attributes: attributes)
        label.textAlignment = .center
        label.preservesSuperviewLayoutMargins = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter your email"
        textField.textContentType = .emailAddress
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private(set) lazy var restoreButton: RoundedBorderButton = {
        let restoreBtn = RoundedBorderButton()
        restoreBtn.cornerRadius = 5
        restoreBtn.backgroundColor = YELLOW_COLOR
        restoreBtn.setupTitleLabel(with: "Restore email")
        return restoreBtn;
    }()
    
    override init(with title: String) {
        super.init(with: title)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    private func configureView() {
        self.emailStackView.addArrangedSubview(fieldLabel)
        self.emailStackView.addArrangedSubview(textField)
        self.addSubview(self.emailStackView)
        self.addSubview(restoreButton)
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.emailStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.emailStackView.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: 20),
            self.emailStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.emailStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            self.restoreButton.heightAnchor.constraint(equalToConstant: 30),
            self.restoreButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            self.restoreButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            //            TODO: debug constraint
            self.restoreButton.topAnchor.constraint(equalTo: self.emailStackView.bottomAnchor, constant: 25)
        ])
    }

}
