//
//  SavingView.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 07/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

class SavingView: UIView, UITextFieldDelegate, Slide {
    
    enum SavingFinding {
        case Empty
        case FutureAmount
        case PaymentAmount
        case NumberOfYears
    }
    
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var futureAmountTF: UITextField!
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var paymentAmountTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    
    @IBOutlet weak var periodSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    
    @IBOutlet weak var cardViewTitle: UILabel!
    @IBOutlet weak var cardViewTitleSpace: UIView!
    
    var finding = SavingFinding.Empty
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        cardView.layer.cornerRadius = 20
        //cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowOpacity = 0.2
        
        calculateButton.layer.cornerRadius = 5
        futureAmountTF.layer.cornerRadius = 5
        initialAmountTF.layer.cornerRadius = 5
        interestRateTF.layer.cornerRadius = 5
        numberOfYearsTF.layer.cornerRadius = 5
        
        let resignSelector = #selector(saveFields)
        NotificationCenter.default.addObserver(self, selector: resignSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
        let switchLabelSelector = #selector(switchLabelTapped(sender:))
        let switchLabelTap = UITapGestureRecognizer(target: self, action: switchLabelSelector)
        switchLabel.addGestureRecognizer(switchLabelTap)
        
        readFields()
    }
    
    func keyboardOpened() {
        UIView.transition(with: superview!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.titleLabel.text = self?.cardViewTitle.text!
            }, completion: nil)
        UIView.animate(withDuration: 0.05, animations: {
            self.cardViewTitle.alpha = 0
            self.cardViewTitleSpace.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.cardViewTitle.isHidden = true
                self.cardViewTitleSpace.isHidden = true
            })
        })
    }
    
    func keyboardClosed() {
        UIView.transition(with: superview!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.titleLabel.text = "Finance App"
            }, completion: nil)
        UIView.animate(withDuration: 0.05, animations: {
            self.cardViewTitle.alpha = 1
            self.cardViewTitleSpace.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.cardViewTitle.isHidden = false
                self.cardViewTitleSpace.isHidden = false
            })
        })
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        let interestRate = interestRateTF.validatedDouble
        let futureAmount = futureAmountTF.validatedDouble
        let paymentAmount = paymentAmountTF.validatedDouble
        let initialAmount = initialAmountTF.validatedDouble
        let numberOfYears = numberOfYearsTF.validatedDouble
        
        let validationError = validateInput(interestRate: interestRate, futureAmount: futureAmount, initialAmount: initialAmount, numberOfYears: numberOfYears, paymentAmount: paymentAmount)
        
        let color = sender.backgroundColor
        
        if validationError == nil {
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                self.calculateButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                sender.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
                self.topBarView.backgroundColor = UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            }, completion: {_ in
                UIView.animate(withDuration: 0.2, animations: {() -> Void in
                    self.calculateButton.transform = CGAffineTransform.identity
                }, completion: { _ in
                    UIView.animate(withDuration: 0.2, delay: 0.6, animations: {() -> Void in
                        sender.backgroundColor = color
                        self.topBarView.backgroundColor = color
                    })
                })
            })
            
            switch finding {
            case .FutureAmount:
                let result: Double
                if (!periodSwitch.isOn) {
                    result = SavingsHelper.futureValueEnd(initialAmount: initialAmount!, paymentAmount: paymentAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                } else {
                    result = SavingsHelper.futureValueBegin(initialAmount: initialAmount!, paymentAmount: paymentAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                }
                futureAmountTF.text = "£ " + String(format: "%.2f", result)
            case .NumberOfYears:
                let result: Double
                if (!periodSwitch.isOn) {
                    result = SavingsHelper.numberOfYearsEnd(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, paymentAmount: paymentAmount!)
                } else {
                    result = SavingsHelper.numberOfYearsBegin(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, paymentAmount: paymentAmount!)
                }
                numberOfYearsTF.text = String(format: "%.2f", result)
            case .PaymentAmount:
                let result: Double
                if (!periodSwitch.isOn) {
                    result = SavingsHelper.paymentAmountEnd(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                } else {
                    result = SavingsHelper.paymentAmountBegin(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                }
                paymentAmountTF.text = "£ " + String(format: "%.2f", result)
            default:
                return
            }
        } else {
            let alertView = HomePageViewController.parentController.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
            alertView.alertTitle = "Validation error!"
            alertView.alertText = validationError!
            alertView.modalPresentationStyle = .overCurrentContext
            alertView.modalTransitionStyle = .crossDissolve
            HomePageViewController.parentController.present(alertView, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func textFieldEdited(_ sender: UITextField) {
        if sender.filteredText == "" {
            sender.text = sender.filteredText
            return
        }
        switch sender.tag {
        case 1:
            sender.text = "£ " + sender.filteredText
        case 2:
            sender.text = sender.filteredText + " %"
        default:
            break
        }
    }
    
    func validateInput(interestRate: Double!, futureAmount: Double!, initialAmount: Double!, numberOfYears: Double!, paymentAmount: Double!) -> String! {
        var counter = 0
        
        if (futureAmount == nil) {
            counter += 1
            finding = .FutureAmount
        }
        
        if (paymentAmount == nil) {
            counter += 1
            finding = .PaymentAmount
        }
        
        if (numberOfYears == nil) {
            counter += 1
            finding = .NumberOfYears
        }
        
        if counter > 1 {
            finding = .Empty
            return "Only one text field can be empty!\n\nPlease, read the help page to get more information!"
        }
        
        if interestRate == nil {
            return "Interest rate cannot be empty!\n\nPlease, read the help page to get more information!"
        }
        
        if initialAmount == nil {
            return "Initial amount cannot be empty!\n\nPlease, read the help page to get more information!"
        }
        
        if counter == 0 && finding == .Empty {
            finding = .Empty
            return "At least one text field must be empty!\n\nPlease, read the help page to get more information!"
        }
        
        if initialAmount != nil && futureAmount != nil {
            if initialAmount > futureAmount {
                return "Initial amount cannot be more than future amount!\n\nPlease, read the help page to get more information!"
            }
        }
        
        if paymentAmount != nil && futureAmount != nil {
            if paymentAmount > futureAmount {
                return "Payment amount cannot be more than future amount!\n\nPlease, read the help page to get more information!"
            }
        }
        
        if numberOfYears != nil && numberOfYears == 0 {
            return "Number of years cannot be zero!\n\nPlease, read the help page to get more information!"
        }
        
        if futureAmount != nil && futureAmount == 0 {
            return "Future amount cannot be zero!\n\nPlease, read the help page to get more information!"
        }
        
        if paymentAmount != nil && paymentAmount == 0 {
            return "Payment amount cannot be zero!\n\nPlease, read the help page to get more information!"
        }
        
        return nil
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        sender.layer.cornerRadius = 5
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            sender.tintColor = .white
            sender.backgroundColor = UIColor(red:0.27, green:0.41, blue:0.78, alpha:1.0)
        }, completion: {_ in
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                sender.tintColor = UIColor(red:0.88, green:0.89, blue:0.90, alpha:1.0)
                sender.backgroundColor = .none
            })
        })
        
        UIView.transition(with: cardView,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.futureAmountTF.text = ""
                            self?.initialAmountTF.text = ""
                            self?.interestRateTF.text = ""
                            self?.numberOfYearsTF.text = ""
                            self?.paymentAmountTF.text = ""
            }, completion: nil)
    }
    
    @IBAction func textFieldEditBegin(_ sender: UITextField) {
        sender.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = textField.filteredText
        
        if let char = string.cString(using: String.Encoding.utf8){
            let isBackspace = strcmp(char, "\\b")
            if (isBackspace == -92){
                textField.text = String(newText.dropLast()) + " "
                return true
            }
        }
        
        let stringParts = newText.components(separatedBy: ".")
        
        if stringParts.count > 1 && string == "." {
            return false
        }
        
        if (stringParts.count == 2 && stringParts[1].count == 2){
            return false
        }
        
        if textField.filteredText == "0" && string != "." {
            textField.text = ""
        }
        
        if textField.filteredText == "" && string == "." {
            textField.text = "0"
        }
        
        return true
    }
    
    @objc func switchLabelTapped(sender:UITapGestureRecognizer) {
        periodSwitch.setOn(!periodSwitch.isOn, animated: true)
        changeSwitchLabel()
    }
    
    func changeSwitchLabel(){
        if periodSwitch.isOn {
            switchLabel.text = "Pay at the beginning of month"
        } else {
            switchLabel.text = "Pay at the end of month"
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        changeSwitchLabel()
    }
    
    @objc func saveFields() {
        defaults.set(futureAmountTF.text, forKey: "savingFutureAmount")
        defaults.set(initialAmountTF.text, forKey: "savingInitialAmount")
        defaults.set(numberOfYearsTF.text, forKey: "savingNumberOfYears")
        defaults.set(interestRateTF.text, forKey: "savingInterestRate")
        defaults.set(paymentAmountTF.text, forKey: "savingPaymentAmount")
        defaults.set(periodSwitch.isOn, forKey: "savingPeriod")
    }
    
    func readFields(){
        futureAmountTF.text = defaults.string(forKey: "savingFutureAmount")
        initialAmountTF.text = defaults.string(forKey: "savingInitialAmount")
        numberOfYearsTF.text = defaults.string(forKey: "savingNumberOfYears")
        interestRateTF.text = defaults.string(forKey: "savingInterestRate")
        paymentAmountTF.text = defaults.string(forKey: "savingPaymentAmount")
        periodSwitch.isOn = defaults.bool(forKey: "savingPeriod")
        changeSwitchLabel()
    }
}
