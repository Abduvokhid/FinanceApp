//
//  LaunchViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 06/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var animateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.layer.cornerRadius = 32
        logoView.tintColor = .none
    }
    
    @IBAction func animateButtonPressed(_ sender: UIButton) {
        let bounds = logoView.frame
        UIView.animate(withDuration: 0.8, animations: {
            self.logoView.frame = CGRect(x: bounds.origin.x + 800, y: bounds.origin.y, width: bounds.size.width + 300, height: bounds.size.height)
        }, completion: { _ in
            self.logoView.frame = CGRect(x: -100, y: bounds.origin.y, width: 50, height: bounds.size.height)
            UIView.animate(withDuration: 0.3, animations: {
                self.logoView.frame = CGRect(x: (self.view.frame.width / 2) - 50 , y: bounds.origin.y, width: 100, height: bounds.size.height)
            })
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
