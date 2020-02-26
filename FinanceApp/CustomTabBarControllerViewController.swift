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
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.viewDidLoad()
    }
    

}
