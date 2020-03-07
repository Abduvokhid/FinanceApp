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
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var paymentAmountTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    
    @IBOutlet weak var cardViewTitle: UILabel!
    @IBOutlet weak var cardViewTitleSpace: UIView!
    
    var finding = MortgageFinding.empty
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        cardView.layer.cornerRadius = 20
        //cardView.layer.shadowPath = UIBezierPath(rect: cardView.bounds).cgPath
        cardView.layer.shadowRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 1, height: 1)
        cardView.layer.shadowOpacity = 0.2
        
        calculateButton.layer.cornerRadius = 5
        initialAmountTF.layer.cornerRadius = 5
        paymentAmountTF.layer.cornerRadius = 5
        interestRateTF.layer.cornerRadius = 5
        numberOfYearsTF.layer.cornerRadius = 5
        
        let resignSelector = #selector(saveFields)
        NotificationCenter.default.addObserver(self, selector: resignSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
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
        let initialAmount = initialAmountTF.validatedDouble
        let paymentAmount = paymentAmountTF.validatedDouble
        let numberOfYears = numberOfYearsTF.validatedDouble
        
        let validationError = validateInput(interestRate: interestRate, initialAmount: initialAmount, paymentAmount: paymentAmount, numberOfYears: numberOfYears)
        
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
            case .initialAmount:
                let result = MortgageHelper.initialValue(paymentAmount: paymentAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                initialAmountTF.text = String(format: "%.2f", result)
            case .numberOfYears:
                let result = MortgageHelper.numberOfYears(initialAmount: initialAmount!, interestRate: interestRate!, paymentAmount: paymentAmount!)
                numberOfYearsTF.text = String(format: "%.2f", result)
            case .paymentAmount:
                let result = MortgageHelper.paymentAmount(initialAmount: initialAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                paymentAmountTF.text = String(format: "%.2f", result)
            default:
                return
            }
        } else {
            let bounds = sender.bounds
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: .curveEaseOut, animations: {
                sender.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width + 40, height: bounds.size.height)
            }) { (success:Bool) in
                if success{
                    UIView.animate(withDuration: 0.5, animations: {
                        sender.bounds = bounds
                        sender.backgroundColor = color
                        self.topBarView.backgroundColor = color
                    })
                }
            }
            UIView.animate(withDuration: 0.2, animations: {
                sender.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                self.topBarView.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
            })
        }
        
    }
    
    func validateInput(interestRate: Double!, initialAmount: Double!, paymentAmount: Double!, numberOfYears: Double!) -> String! {
        var counter = 0
        
        if (initialAmount == nil) {
            counter += 1
            finding = .initialAmount
        }
        
        if (paymentAmount == nil) {
            counter += 1
            finding = .paymentAmount
        }
        
        if (numberOfYears == nil) {
            counter += 1
            finding = .numberOfYears
        }
        
        if ((counter == 0 && finding == .empty) || counter > 1) {
            finding = .empty
            return "Only one text field can be empty!\n\nPlease, read the help page to get more information!"
        }
        
        if (interestRate == nil) {
            return "Interest rate cannot be empty!\n\nPlease, read the help page to get more information!"
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
                            self?.initialAmountTF.text = ""
                            self?.paymentAmountTF.text = ""
                            self?.interestRateTF.text = ""
                            self?.numberOfYearsTF.text = ""
            }, completion: nil)
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
    
    @objc func saveFields() {
        defaults.set(initialAmountTF.text, forKey: "mortgageInitialAmount")
        defaults.set(paymentAmountTF.text, forKey: "mortgagePaymentAmount")
        defaults.set(numberOfYearsTF.text, forKey: "mortgageNumberOfYears")
        defaults.set(interestRateTF.text, forKey: "mortgageInterestRate")
    }
    
    func readFields(){
        initialAmountTF.text = defaults.string(forKey: "mortgageInitialAmount")
        paymentAmountTF.text = defaults.string(forKey: "mortgagePaymentAmount")
        numberOfYearsTF.text = defaults.string(forKey: "mortgageNumberOfYears")
        interestRateTF.text = defaults.string(forKey: "mortgageInterestRate")
    }
    
}
