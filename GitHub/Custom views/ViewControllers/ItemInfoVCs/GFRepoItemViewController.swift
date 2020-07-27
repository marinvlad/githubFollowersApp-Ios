//
//  GFRepoItemViewController.swift
//  GitHub
//
//  Created by Vlad on 7/27/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit
class GFRepoItemViewController : GFItemInfoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonPressed() {
        delegate.didTapGitHubProfile(user: user)
    }
}
