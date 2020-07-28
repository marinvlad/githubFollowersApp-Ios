//
//  GFTabBarController.swift
//  GitHub
//
//  Created by Vlad on 7/28/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class GFTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(), createFavoritesNavigationController()]
    }
    
    
    func createSearchNavigationController() -> UINavigationController {
        let search = SearchViewController()
        search.title = "Search"
        search.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: search)
    }
    
    func createFavoritesNavigationController() -> UINavigationController {
        let favorite = FavoritesViewController()
        favorite.title = "Favorites"
        favorite.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        return UINavigationController(rootViewController: favorite)
    }
}
