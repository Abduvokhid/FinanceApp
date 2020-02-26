//
//  LoanViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 24/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

enum LoanFinding {
    case empty
    case initialAmount
    case paymentAmount
    case numberOfMonths
}

class LoanViewController: UIViewController {
    
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var paymentAmountTF: UITextField!
    @IBOutlet weak var numberOfMonthsTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    var currentTextField: UITextField!
    
    var finding = LoanFinding.empty
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resignSelector = #selector(self.saveFields)
        NotificationCenter.default.addObserver(self, selector: resignSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
        readFields()
    }
    
    @objc func saveFields() {
        defaults.set(paymentAmountTF.text, forKey: "loanPaymentAmount")
        defaults.set(initialAmountTF.text, forKey: "loanInitialAmount")
        defaults.set(interestRateTF.text, forKey: "loanInterestRate")
        defaults.set(numberOfMonthsTF.text, forKey: "loanNumberOfMonths")
    }
    
    func readFields(){
        paymentAmountTF.text = defaults.string(forKey: "loanPaymentAmount")
        initialAmountTF.text = defaults.string(forKey: "loanInitialAmount")
        interestRateTF.text = defaults.string(forKey: "loanInterestRate")
        numberOfMonthsTF.text = defaults.string(forKey: "loanNumberOfMonths")
    }    
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
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
        
        let numberOfMonths: Double! = Double(numberOfMonthsTF.text!)
        if (numberOfMonths == nil) {
            counter += 1
            finding = .numberOfMonths
        }
        
        if ((counter == 0 && finding == .empty) || counter > 1) {
            finding = .empty
            return
        }
        
        switch finding {
        case .initialAmount:
            let result = MortgageHelper.initialValue(paymentAmount: paymentAmount, interestRate: interestRate, numberOfYears: numberOfMonths / 12)
            initialAmountTF.text = String(format: "%.2f", result)
        case .numberOfMonths:
            let result = MortgageHelper.numberOfYears(initialAmount: initialAmount, interestRate: interestRate, paymentAmount: paymentAmount)
            numberOfMonthsTF.text = String(format: "%.2f", result * 12)
        case .paymentAmount:
            let result = MortgageHelper.paymentAmount(initialAmount: initialAmount, interestRate: interestRate, numberOfYears: numberOfMonths / 12)
            paymentAmountTF.text = String(format: "%.2f", result)
        default:
            return
        }
    }

}
