//
//  MortgageView.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 05/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class MortgageView: UIView, UITextFieldDelegate, Slide {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    
    override func awakeFromNib() {
        cardView.layer.cornerRadius = 20
        //cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowOpacity = 0.2
        
        calculateButton.layer.cornerRadius = 5
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            self.calculateButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.calculateButton.transform = CGAffineTransform.identity
            })
        })
    }
    
    @IBAction func textFieldEditBegin(_ sender: UITextField) {
        sender.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let amountOfDots = textField.text!.components(separatedBy: ".").count
        if amountOfDots > 1 && string == "." {
            return false
        }
        return true
    }
    
}
