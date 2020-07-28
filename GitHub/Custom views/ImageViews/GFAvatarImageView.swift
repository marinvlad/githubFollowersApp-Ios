//
//  GFAvatarImageView.swift
//  GitHub
//
//  Created by Vlad on 7/24/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeHolderImage = Images.avatarPlaceholder
    let networkCache = NetworkManager.shared.cache
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        image = placeHolderImage
    }
    
    func setImage(withString url : String) {
        NetworkManager.shared.downloadImage(url: url) { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
