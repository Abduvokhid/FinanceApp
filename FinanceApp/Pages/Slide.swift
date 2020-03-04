//
//  Slide.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 04/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class Slide: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func calculate(_ sender: UIButton) {
        label.text = "this is test from ..."
        
        //HomePageViewController.parentView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
