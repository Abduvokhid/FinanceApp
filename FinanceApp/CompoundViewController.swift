//
//  SecondViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 18/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

enum CompoundFinding {
    case Empty
    case FutureValue
    case InitialAmount
    case NumberOfYears
    case InterestRate
}

class CompoundViewController: UIViewController{

    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    var currentTextField: UITextField!
    
    var finding = CompoundFinding.Empty
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
        defaults.set(futureValueTF.text, forKey: "compoundFutureValue")
        defaults.set(initialAmountTF.text, forKey: "compoundInitialAmount")
        defaults.set(interestRateTF.text, forKey: "compoundInterestRate")
        defaults.set(numberOfYearsTF.text, forKey: "compoundNumberOfYears")
    }
    
    func readFields(){
        futureValueTF.text = defaults.string(forKey: "compoundFutureValue")
        initialAmountTF.text = defaults.string(forKey: "compoundInitialAmount")
        interestRateTF.text = defaults.string(forKey: "compoundInterestRate")
        numberOfYearsTF.text = defaults.string(forKey: "compoundNumberOfYears")
    }    
    
    @IBAction func calculatePressed(_ sender: Any) {
        var counter = 0
        
        let futureValue: Double! = Double(futureValueTF.text!)
        if (futureValue == nil) {
            counter += 1
            finding = CompoundFinding.FutureValue
        }
        
        let initialAmount: Double! = Double(initialAmountTF.text!)
        if (initialAmount == nil) {
            counter += 1
            finding = CompoundFinding.InitialAmount
        }
        
        let numberOfYears: Double! = Double(numberOfYearsTF.text!)
        if (numberOfYears == nil) {
            counter += 1
            finding = CompoundFinding.NumberOfYears
        }
        
        let interestRate: Double! = Double(interestRateTF.text!)
        if (interestRate == nil) {
            counter += 1
            finding = CompoundFinding.InterestRate
        }
        
        if ((counter == 0 && finding == CompoundFinding.Empty) || counter > 1) {
            finding = CompoundFinding.Empty
            return
        }
        
        switch finding {
        case .FutureValue:
            let result = CompoundHelper.CalculateFutureValue(interestRate: interestRate, initialAmount: initialAmount, numberOfYears: numberOfYears)
            futureValueTF.text = String(format: "%.2f", result)
            break
        case .InitialAmount:
            let result = CompoundHelper.CalculateInitialAmount(interestRate: interestRate, futureValue: futureValue, numberOfYears: numberOfYears)
            initialAmountTF.text = String(format: "%.2f", result)
            break
        case .NumberOfYears:
            let result = CompoundHelper.CalculateNumberOfYears(interestRate: interestRate, futureValue: futureValue, initialAmount: initialAmount)
            numberOfYearsTF.text = String(format: "%.2f", result)
            break
        case .InterestRate:
            let result = CompoundHelper.CalculateInterestRate(futureValue: futureValue, initialAmount: initialAmount, numberOfYears: numberOfYears)
            interestRateTF.text = String(format: "%.2f", result * 100)
        default:
            return
        }
        
        
    }
 
}

