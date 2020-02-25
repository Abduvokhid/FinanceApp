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
    
    override func viewWillAppear(_ animated: Bool) {
        //add a notification for when the keyboard shows and call keyboardWillShow when the keyboard is to        be shown
        let sel = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        //this moves the tab bar above the keyboard for all devices
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (KB.keyBoardHeight == 0){
                KB.keyBoardHeight = keyboardSize.origin.y - keyboardSize.height -
                    (self.tabBarController?.tabBar.frame.height)!
            }
            KB.isOpen = true
        }
        var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        KB.currentLoc = tabBarFrame.origin.y
        tabBarFrame.origin.y = KB.keyBoardHeight
        self.tabBarController?.tabBar.frame = tabBarFrame
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
        if (KB.isOpen){
            var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
            tabBarFrame.origin.y = KB.currentLoc
            self.tabBarController?.tabBar.frame = tabBarFrame
            KB.isOpen = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sel = #selector(self.closeKeyboard)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: sel)
        view.addGestureRecognizer(tap)
        
        let tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
        if KB.isFirst {
            KB.defaultLoc = tabBarFrame.origin.y
            KB.currentLoc = tabBarFrame.origin.y
            KB.isFirst = false
        } else {
            KB.currentLoc = KB.defaultLoc
        }
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

