//
//  GFEmptyStateView.swift
//  GitHub
//
//  Created by Vlad on 7/26/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class GFEmptyStateView: UIView {
    
    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message : String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    func configure() {
        addSubviews(views: imageView, messageLabel)
        
        configureMessageLabel()
        configureImageView()
    }
    
    func configureMessageLabel(){
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureImageView() {
        imageView.image = Images.emptyStateLogo
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            imageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }

}
