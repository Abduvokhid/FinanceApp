//
//  HelpPageViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 09/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class HelpPageViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var dismissButtonShadowView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var helpTextView: UITextView!
    @IBOutlet weak var helpImageView: UIImageView!
    
    var titleText: String = ""
    var helpText: String = ""
    var helpFormula: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.layer.cornerRadius = 25
        dismissButtonShadowView.layer.cornerRadius = 25
        
        dismissButtonShadowView.layer.shadowRadius = 5
        dismissButtonShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dismissButtonShadowView.layer.shadowOpacity = 0.5
        
        titleLabel.text = titleText
        helpImageView.image = helpFormula
        
        helpTextView.attributedText = helpText.htmlAttributed(family: "Arial", size: 12, color: "2c3e50")!
    }
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
