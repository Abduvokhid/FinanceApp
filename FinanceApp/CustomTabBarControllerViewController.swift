//
//  CustomTabBarControllerViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 23/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class CustomTabBarControllerViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.backgroundColor = .white
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBar.tintColor = viewController.view.backgroundColor
        viewController.viewDidLoad()
    }
    
}
