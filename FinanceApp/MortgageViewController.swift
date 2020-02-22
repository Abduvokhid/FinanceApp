//
//  MortgageViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 22/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

enum MortgageFinding {
    case empty
    case initialAmount
    case paymentAmount
    case numberOfYears
}

class MortgageViewController: UIViewController {

    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var paymentAmountTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    
    @IBOutlet weak var dummyView: UIView!
    
    @IBOutlet weak var keyboardView: UIView!
    
    var current = 0
    
    var open = false
    
    @IBAction func TextFieldFocused(_ sender: UITextField) {
        switch sender.tag {
        case 1:
            current = 1
        case 2:
            current = 2
        case 3:
            current = 3
        case 4:
            current = 4
        default:
            return
        }
        if (!open){
            keyboardView.isHidden = false
            open = true
        }
    }
    
    @objc func hideKeyboard(){
        keyboardView.isHidden = true
        open = false
    }
    
    @IBAction func KeyboardButtonPressed(_ sender: UIButton) {
        let now: String
        let pressed: String = sender.titleLabel!.text ?? ""
        switch pressed {
        case "1":
            now = "1"
        case "2":
            now = "2"
        case "3":
            now = "3"
        case "4":
            now = "4"
        case "-1":
            now = "-1"
        default:
            return
        }
        switch current {
        case 1:
            initialAmountTF.text = (initialAmountTF.text ?? "") + now
        case 2:
            paymentAmountTF.text = (paymentAmountTF.text ?? "") + now
        case 3:
            numberOfYearsTF.text = (numberOfYearsTF.text ?? "") + now
        case 4:
            interestRateTF.text = (interestRateTF.text ?? "") + now
        default:
            return
        }
    }
    
    @IBOutlet var mainView: UIView!
    
    var finding = MortgageFinding.empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardSelector = #selector(self.hideKeyboard)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: hideKeyboardSelector)
        mainView.addGestureRecognizer(tap)
    }
    
    @IBAction func calculateButtonPressed(_ sender: Any) {
        var counter = 0
        
        let interestRate: Double! = Double(interestRateTF.text!)
        if (interestRate == nil) {
            return
        }
        
        let initialAmount: Double! = Double(initialAmountTF.text!)
        if (initialAmount == nil) {
            counter += 1
            finding = .initialAmount
        }
        
        let paymentAmount: Double! = Double(paymentAmountTF.text!)
        if (paymentAmount == nil) {
            counter += 1
            finding = .paymentAmount
        }
        
        let numberOfYears: Double! = Double(numberOfYearsTF.text!)
        if (numberOfYears == nil) {
            counter += 1
            finding = .numberOfYears
        }
        
        if ((counter == 0 && finding == .empty) || counter > 1) {
            finding = .empty
            return
        }
        
        switch finding {
        case .initialAmount:
            let result = MortgageHelper.initialValue(paymentAmount: paymentAmount, interestRate: interestRate, numberOfYears: numberOfYears)
            initialAmountTF.text = String(format: "%.2f", result)
        case .numberOfYears:
            let result = MortgageHelper.numberOfYears(initialAmount: initialAmount, interestRate: interestRate, paymentAmount: paymentAmount)
            numberOfYearsTF.text = String(format: "%.2f", result)
        case .paymentAmount:
            let result = MortgageHelper.paymentAmount(initialAmount: initialAmount, interestRate: interestRate, numberOfYears: numberOfYears)
            paymentAmountTF.text = String(format: "%.2f", result)
            
            /*let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .currency
            formatter.currencyGroupingSeparator = " "
            formatter.currencyDecimalSeparator = "."
            formatter.currencySymbol = "£"
            paymentAmountTF.text = formatter.string(for: result)*/
        default:
            return
        }
    }
}
