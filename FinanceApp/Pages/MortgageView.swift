//
//  MortgageView.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 05/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class MortgageView: UIView, UITextFieldDelegate {
    
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
