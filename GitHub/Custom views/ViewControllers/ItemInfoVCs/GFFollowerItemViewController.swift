//
//  GFFollowerItemViewController.swift
//  GitHub
//
//  Created by Vlad on 7/27/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit
class GFFollowerItemViewController : GFItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}

