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
    
    var titleText: String = ""
    var helpText: String = ""
    var helpAttributes: [AttributeInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.layer.cornerRadius = 25
        dismissButtonShadowView.layer.cornerRadius = 25
        
        dismissButtonShadowView.layer.shadowRadius = 5
        dismissButtonShadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dismissButtonShadowView.layer.shadowOpacity = 0.5
        
        titleLabel.text = titleText
        
        let commonAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        let boldAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
        
        let newText: NSMutableAttributedString = NSMutableAttributedString(attributedString: helpText.htmlAttributed(family: "Arial", size: 12, color: "2c3e50")!)
        //let newText: NSMutableAttributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: helpText))
        
        //newText.addAttributes(commonAttribute, range: NSRange(location: 0, length: helpText.count))
        
        for helpAttribute in helpAttributes {
            let attribute: [NSAttributedString.Key: Any]
            switch helpAttribute.type {
            case .Bold:
                attribute = boldAttribute
            default:
                attribute = commonAttribute
            }
            newText.addAttributes(attribute, range: NSRange(location: helpAttribute.start, length: helpAttribute.length))
        }
        
        
        helpTextView.attributedText = newText
    }
    
    @IBAction func dismissSecondVC(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
