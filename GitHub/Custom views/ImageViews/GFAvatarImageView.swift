//
//  GFAvatarImageView.swift
//  GitHub
//
//  Created by Vlad on 7/24/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeHolderImage = UIImage(named: "avatar-placeholder")
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
    
    func downloadImage(url : String) {
        let cacheKey = NSString(string: url)
        
        if let image = networkCache.object(forKey: cacheKey) {
            self.image = image
            return
        }
        
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            self.networkCache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
