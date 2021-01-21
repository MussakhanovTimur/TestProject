//
//  MainTabBarController.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 16.01.2021.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        viewControllers = [generateViewController(rootViewController: SearchCollectionViewController(),
                                                  image: #imageLiteral(resourceName: "search"),
                                                  title: "Поиск"),
                           generateViewController(rootViewController: HistoryTableViewController(),
                                                  image: #imageLiteral(resourceName: "library"),
                                                  title: "История")]
    }
    
    private func generateViewController(rootViewController: UIViewController,
                                        image: UIImage,
                                        title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        rootViewController.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }

}
