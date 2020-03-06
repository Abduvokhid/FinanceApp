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

class MortgageViewController: UIViewController{
    
    @IBOutlet weak var logo: UIImageView!
    var isLogoHidden = false
    @IBAction func textFieldFocused(_ sender: UITextField) {
        if !isLogoHidden{
            logo.removeConstraints(logo.constraints)
            logo.heightAnchor.constraint(equalToConstant: 0).isActive = true
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.view.layoutIfNeeded()
                self.logo.alpha = 0
            }, completion: {_ in
                self.logo.isHidden = true
            })
            isLogoHidden = true
        }
    }
    
    func extraMethod() {
        /*var tabBarFrame: CGRect = (self.logo?.frame)!
        tabBarFrame.origin.y = 0
        UIView.animate(withDuration: 0.25, animations: {() -> Void in
            self.logo?.alpha = 0
            self.logo?.frame = tabBarFrame
            UIView.animate(withDuration: 0.6,
                           animations: {
                            self.logo?.transform = CGAffineTransform(scaleX: 1, y: 0.01)
            },
                           completion: { _ in
                            self.logo?.isHidden = true
            })
        })*/
    }
    

    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var paymentAmountTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    var currentTextField: UITextField!
    
    var finding = MortgageFinding.empty
    let defaults = UserDefaults.standard
    var isJustOpened = true
    
    override func viewWillAppear(_ animated: Bool) {
        let sel = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if (!KB.isOpen){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if (KB.tabBarConstant == -1) {
                    KB.tabBarConstant = keyboardSize.origin.y - keyboardSize.height -
                        (self.tabBarController?.tabBar.frame.height)!
                }
            }
            var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
            if (KB.defaultLoc == -1) {
                KB.defaultLoc = tabBarFrame.origin.y
            }
            tabBarFrame.origin.y = KB.tabBarConstant
            self.tabBarController?.tabBar.frame = tabBarFrame
            KB.isOpen = true
        }
    }
    
    @objc func closeKeyboard(){
        if isLogoHidden{
            logo.removeConstraints(logo.constraints)
            self.logo.isHidden = false
            logo.heightAnchor.constraint(equalToConstant: CGFloat(120)).isActive = true
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.view.layoutIfNeeded()
                self.logo.alpha = 1
            }, completion: {_ in
            })
            isLogoHidden = false
        }
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
//        defaults.set(initialAmountTF.text, forKey: "mortgageInitialAmount")
//        defaults.set(paymentAmountTF.text, forKey: "mortgagePaymentAmount")
//        defaults.set(numberOfYearsTF.text, forKey: "mortgageNumberOfYears")
//        defaults.set(interestRateTF.text, forKey: "mortgageInterestRate")
    }
    
    func readFields(){
//        initialAmountTF.text = defaults.string(forKey: "mortgageInitialAmount")
//        paymentAmountTF.text = defaults.string(forKey: "mortgagePaymentAmount")
//        numberOfYearsTF.text = defaults.string(forKey: "mortgageNumberOfYears")
//        interestRateTF.text = defaults.string(forKey: "mortgageInterestRate")
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
