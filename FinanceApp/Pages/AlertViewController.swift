//
//  AlertViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 09/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alertTextView: UITextView!
    @IBOutlet weak var okayButton: UIButton!
    
    @IBOutlet weak var mainViewConstraint: NSLayoutConstraint!
    
    var alertTitle: String = ""
    var alertText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = alertTitle
        alertTextView.text = alertText
        
        mainViewConstraint.constant = (view.frame.height - mainView.frame.height) / 2
        view.layoutIfNeeded()
        
        mainView.layer.cornerRadius = 20
        okayButton.layer.cornerRadius = 5
        UIView.animate(withDuration: 0.2, animations: {
            self.mainView.layer.shadowRadius = 10
            self.mainView.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.mainView.layer.shadowOpacity = 0.2
        })
    }
    
    @IBAction func okayButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
