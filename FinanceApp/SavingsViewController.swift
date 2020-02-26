//
//  FirstViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 18/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

enum SavingsFinding{
    case empty
    case futureValue
    case paymentAmount
    case numberOfYears
}

class SavingsViewController: UIViewController {

    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var paymentAmountTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    @IBOutlet weak var savingsType: UISegmentedControl!
    
    var finding = SavingsFinding.empty
    let defaults = UserDefaults.standard
    var isJustOpened = true
    
    override func viewWillAppear(_ animated: Bool) {
        let sel = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (!KB.isOpen){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if (KB.keyBoardHeight == -1) {
                    KB.keyBoardHeight = keyboardSize.origin.y - keyboardSize.height -
                        (self.tabBarController?.tabBar.frame.height)!
                }
            }
            var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
            if (KB.defaultLoc == -1) {
                KB.defaultLoc = tabBarFrame.origin.y
            }
            tabBarFrame.origin.y = KB.keyBoardHeight
            self.tabBarController?.tabBar.frame = tabBarFrame
            KB.isOpen = true
        }
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
        if (KB.isOpen){
            var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
            tabBarFrame.origin.y = KB.defaultLoc
            self.tabBarController?.tabBar.frame = tabBarFrame
            KB.isOpen = false
        }
    }
    
    override func viewDidLoad() {
        if (isJustOpened){
            super.viewDidLoad()
            isJustOpened = false
            let sel = #selector(self.closeKeyboard)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: sel)
            view.addGestureRecognizer(tap)
            
            let resignSelector = #selector(self.saveFields)
            NotificationCenter.default.addObserver(self, selector: resignSelector, name: UIApplication.willResignActiveNotification, object: nil)
            
            readFields()
        }
        closeKeyboard()
    }
    
    @objc func saveFields() {
        defaults.set(futureValueTF.text, forKey: "savingsFutureValue")
        defaults.set(initialAmountTF.text, forKey: "savingsInitialAmount")
        defaults.set(paymentAmountTF.text, forKey: "savingsPaymentAmount")
        defaults.set(interestRateTF.text, forKey: "savingsInterestRate")
        defaults.set(numberOfYearsTF.text, forKey: "savingsNumberOfYears")
        defaults.set(savingsType.selectedSegmentIndex, forKey: "savingsType")
    }
    
    func readFields(){
        futureValueTF.text = defaults.string(forKey: "savingsFutureValue")
        initialAmountTF.text = defaults.string(forKey: "savingsInitialAmount")
        paymentAmountTF.text = defaults.string(forKey: "savingsPaymentAmount")
        interestRateTF.text = defaults.string(forKey: "savingsInterestRate")
        numberOfYearsTF.text = defaults.string(forKey: "savingsNumberOfYears")
        savingsType.selectedSegmentIndex = defaults.integer(forKey: "savingsType")
    }    

    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        var counter = 0
        
        let interestRate: Double! = Double(interestRateTF.text!)
        if (interestRate == nil) {
            return
        }
        
        let futureValue: Double! = Double(futureValueTF.text!)
        if (futureValue == nil) {
            counter += 1
            finding = .futureValue
        }
        
        let initialAmount: Double! = Double(initialAmountTF.text!)
        if (initialAmount == nil) {
            counter += 1
            if (finding == .futureValue) {return}
        }
        
        let numberOfYears: Double! = Double(numberOfYearsTF.text!)
        if (numberOfYears == nil) {
            counter += 1
            finding = .numberOfYears
        }
        
        let paymentAmount: Double! = Double(paymentAmountTF.text!)
        if (paymentAmount == nil) {
            counter += 1
            finding = .paymentAmount
        }
        
        if ((counter == 0 && finding == .empty) || counter > 1) {
            finding = .empty
            return
        }
        
        
        switch finding {
        case .futureValue:
            let result: Double
            if (savingsType.selectedSegmentIndex == 1) {
                result = SavingsHelper.futureValueEnd(initialAmount: initialAmount, paymentAmount: paymentAmount, interestRate: interestRate, numberOfYears: numberOfYears)
            } else {
                result = SavingsHelper.futureValueBegin(initialAmount: initialAmount, paymentAmount: paymentAmount, interestRate: interestRate, numberOfYears: numberOfYears)
            }
            futureValueTF.text = String(format: "%.2f", result)
        case .numberOfYears:
            let result: Double
            if (savingsType.selectedSegmentIndex == 1) {
                result = SavingsHelper.numberOfYearsEnd(initialAmount: initialAmount, futureValue: futureValue, interestRate: interestRate, paymentAmount: paymentAmount)
            } else {
                result = SavingsHelper.numberOfYearsBegin(initialAmount: initialAmount, futureValue: futureValue, interestRate: interestRate, paymentAmount: paymentAmount)
            }
            numberOfYearsTF                                                                                            .text = String(format: "%.2f", result)
        case .paymentAmount:
            let result: Double
            if (savingsType.selectedSegmentIndex == 1) {
                result = SavingsHelper.paymentAmountEnd(initialAmount: initialAmount, futureValue: futureValue, interestRate: interestRate, numberOfYears: numberOfYears)
            } else {
                result = SavingsHelper.paymentAmountBegin(initialAmount: initialAmount, futureValue: futureValue, interestRate: interestRate, numberOfYears: numberOfYears)
            }
            paymentAmountTF.text = String(format: "%.2f", result)
        default:
            return
        }
    }

}

