//
//  MainTabBarViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Color.mainColor
        tabBar.unselectedItemTintColor = Color.lightgray
        
        let search = SearchMainViewController()
        let nav1 = UINavigationController(rootViewController: search)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let setting = SettingViewController()
        let nav2 = UINavigationController(rootViewController: setting)
        nav2.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 1)
        
        setViewControllers([nav1, nav2], animated: true)
    }

  

}
