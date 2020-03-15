//
//  SavingView.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 07/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

//
// As all 4 slides (views) have same methods and implementation, more detailed comments were written in MortgageView.swift file
// Comments were written only for complex snippets of code as it is mentioned in Coursework description
//

class SavingView: UIView, UITextFieldDelegate, Slide {
    
    // This enum is used to identify which text field must be calculated
    enum SavingFinding {
        case Empty
        case FutureAmount
        case PaymentAmount
        case NumberOfYears
    }
    
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var stackView: UIStackView!
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
    
    @IBOutlet weak var errorTextView: UITextView!
    
    var finding = SavingFinding.Empty
    let defaults = UserDefaults.standard
    
    // This method is executed when current view is generated in a parent view
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
        
        errorTextView.alpha = 0
        errorTextView.textColor = Colors.Red
        
        let resignSelector = #selector(saveFields)
        NotificationCenter.default.addObserver(self, selector: resignSelector, name: UIApplication.willResignActiveNotification, object: nil)
        
        let switchLabelSelector = #selector(switchLabelTapped(sender:))
        let switchLabelTap = UITapGestureRecognizer(target: self, action: switchLabelSelector)
        switchLabel.addGestureRecognizer(switchLabelTap)
        
        readFields()
    }
    
    // This method animates the page accordingly when keyboard is opened
    func keyboardOpened() {
        UIView.transition(with: superview!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.titleLabel.text = self?.cardViewTitle.text!
            }, completion: nil)
        
        for childView in self.stackView.subviews {
            if childView.tag == 1 {
                childView.removeConstraints(childView.constraints)
                childView.heightAnchor.constraint(equalToConstant: 5).isActive = true
            }
            if childView is UILabel && childView.tag == 0 {
                childView.removeConstraints(childView.constraints)
                childView.heightAnchor.constraint(equalToConstant: 17).isActive = true
            }
            if childView is UITextField {
                childView.removeConstraints(childView.constraints)
                childView.heightAnchor.constraint(equalToConstant: 35).isActive = true
            }
        }
        
        self.cardViewTitle.removeConstraints(self.cardViewTitle.constraints)
        self.cardViewTitle.heightAnchor.constraint(equalToConstant: 0).isActive = true
        self.cardViewTitleSpace.removeConstraints(self.cardViewTitleSpace.constraints)
        self.cardViewTitleSpace.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cardViewTitle.alpha = 0
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: nil)
        })
        
    }
    
    // This method returns all views back to their default style when keyboard is closed
    func keyboardClosed() {
        UIView.transition(with: superview!,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.titleLabel.text = "Finance App"
            }, completion: nil)
        
        for childView in self.stackView.subviews {
            if childView.tag == 1 {
                childView.removeConstraints(childView.constraints)
                childView.heightAnchor.constraint(equalToConstant: 10).isActive = true
            }
            if childView is UILabel && childView.tag == 0 {
                childView.removeConstraints(childView.constraints)
                childView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            }
            if childView is UITextField {
                childView.removeConstraints(childView.constraints)
                childView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }
        }
        
        self.cardViewTitle.removeConstraints(self.cardViewTitle.constraints)
        self.cardViewTitle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.cardViewTitleSpace.removeConstraints(self.cardViewTitleSpace.constraints)
        self.cardViewTitleSpace.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.cardViewTitle.alpha = 1
        }, completion: {_ in
            UIView.animate(withDuration: 0.3, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: nil)
        })
    }
    
    // Here text fields are validated and necessary field is calculated
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        // Closing the keyboard when Calculate button is pressed
        HomePageViewController.parentController.closeKeyboard()
        
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
                    result = MonthlySavingHelper.futureValueEnd(initialAmount: initialAmount!, paymentAmount: paymentAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                } else {
                    result = MonthlySavingHelper.futureValueBegin(initialAmount: initialAmount!, paymentAmount: paymentAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                }
                futureAmountTF.text = "£ " + String(format: "%.2f", result)
            case .NumberOfYears:
                let result: Double
                if (!periodSwitch.isOn) {
                    result = MonthlySavingHelper.numberOfYearsEnd(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, paymentAmount: paymentAmount!)
                } else {
                    result = MonthlySavingHelper.numberOfYearsBegin(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, paymentAmount: paymentAmount!)
                }
                numberOfYearsTF.text = String(format: "%.2f", result)
            case .PaymentAmount:
                let result: Double
                if (!periodSwitch.isOn) {
                    result = MonthlySavingHelper.paymentAmountEnd(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                } else {
                    result = MonthlySavingHelper.paymentAmountBegin(initialAmount: initialAmount!, futureAmount: futureAmount!, interestRate: interestRate!, numberOfYears: numberOfYears!)
                }
                paymentAmountTF.text = "£ " + String(format: "%.2f", result)
            default:
                return
            }
        } else {
            errorTextView.text = validationError!
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.error)
            UIView.animate(withDuration: 0.2, animations: {
                sender.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                self.topBarView.backgroundColor = UIColor(red:0.75, green:0.22, blue:0.17, alpha:1.0)
                self.errorTextView.alpha = 1
            }, completion: {_ in
                UIView.animate(withDuration: 0.5, delay: 2, animations: {
                    sender.backgroundColor = color
                    self.topBarView.backgroundColor = color
                    self.errorTextView.alpha = 0
                })
            })
        }
        
    }
    
    // This method is adding necessary symbols to the textfield
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
    
    // Current method is validating textfield data
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
            return "Only one text field can be empty!\nPlease, read the help page to get more information!"
        }
        
        if interestRate == nil {
            return "Interest rate cannot be empty!\nPlease, read the help page to get more information!"
        }
        
        if initialAmount == nil {
            return "Initial amount cannot be empty!\nPlease, read the help page to get more information!"
        }
        
        if counter == 0 && finding == .Empty {
            finding = .Empty
            return "At least one text field must be empty!\nPlease, read the help page to get more information!"
        }
        
        if initialAmount != nil && futureAmount != nil {
            if initialAmount > futureAmount {
                return "Initial amount cannot be more than future amount!\nPlease, read the help page to get more information!"
            }
        }
        
        if paymentAmount != nil && futureAmount != nil {
            if paymentAmount > futureAmount {
                return "Payment amount cannot be more than future amount!\nPlease, read the help page to get more information!"
            }
        }
        
        if numberOfYears != nil && numberOfYears == 0 {
            return "Number of years cannot be zero!\nPlease, read the help page to get more information!"
        }
        
        if futureAmount != nil && futureAmount == 0 {
            return "Future amount cannot be zero!\nPlease, read the help page to get more information!"
        }
        
        if paymentAmount != nil && paymentAmount == 0 {
            return "Payment amount cannot be zero!\nPlease, read the help page to get more information!"
        }
        
        return nil
    }
    
    // When user presses the Clear button, current method is clearing text from all textfields with transition (smoothly)
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
    
    // Current method is calling help page
    @IBAction func helpButtonPressed(_ sender: UIButton) {
        HomePageViewController.parentController.closeKeyboard()
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
        
        // Creating instance of the help page controller and passing data to be shown in that page
        let helpPage = HomePageViewController.parentController.storyboard?.instantiateViewController(withIdentifier: "HelpPageViewController") as! HelpPageViewController
        helpPage.titleText = "Monthly Savings help page"
        helpPage.helpText = "<b>Future amount</b> (A) – In this box, it is required to insert the amount of money the user is planning to get back in a near future.</br><i>Please leave this box empty if you are looking for the Future amount.</i></br></br><b>Initial amount</b> (P) – In this box, it is required to insert the amount of money that the user currently is planning to deposit.</br><i>This box cannot be empty.</i></br></br><b>Payment amount</b> (PMT) - In this box, it is required to insert the amount of saving that the user is planning to deposit every month.</br><i>Please leave this box empty if you are looking for the Payment amount.</i></br></br><b>Interest rate</b> (r) - In this box, it is required to insert the interest rate user is expecting to have for the monthly saving.</br><i>This box cannot be empty.</i></br></br><b>Number of years</b> (t) - In this box, it is required to insert the period of time (years) within what user expects to get back the deposit with it's interests.</br><i>Please leave this box empty if you are looking for Number of years.</i></br></br><b>Payment period</b> - Please set the period of monthly contribution/payment you want to deposit every month. Future amount will be calculated depending on the period of payment. </br></br><b>Calculate</b> – press Calculate button to get the desired result.</br><i>Please leave empty the box you are expecting to get the result for.</i></br></br><b>Calculations are done based on the current formula:</b>"
        helpPage.helpFormula = UIImage(named: "savingsFormula")
        
        HomePageViewController.parentController.present(helpPage, animated: true, completion: nil)
    }
    
    // This method is changing border color of the textfield which user selected
    @IBAction func textFieldEditBegin(_ sender: UITextField) {
        sender.delegate = self
        sender.layer.borderWidth = 1
        changeBorderColor(sender: sender, fromColor: Colors.Gray.cgColor, toColor: Colors.Blue.cgColor)
    }
    
    // This method is changing border color back to default color when user finishes editing the textfield
    @IBAction func textFieldEditEnd(_ sender: UITextField) {
        changeBorderColor(sender: sender, fromColor: Colors.Blue.cgColor, toColor: Colors.Gray.cgColor)
        sender.layer.borderWidth = 0
    }
    
    // This is common method for changing border color of the textfield. Used both when user starts and ends textfield editing
    func changeBorderColor(sender: UITextField, fromColor: CGColor, toColor: CGColor) {
        let color = CABasicAnimation(keyPath: "borderColor");
        color.fromValue = fromColor
        color.toValue = toColor
        color.duration = 0.3;
        color.repeatCount = 1;
        sender.layer.borderColor = toColor
        sender.layer.add(color, forKey: "borderColor");
    }
    
    // This method is called whenever user presses any button on the keyboard when textfield is active. Last change will be canceled if false is returned from this method. Otherwise changes will be applied
    // Current method is used to set some rules for textfields: only one decimal separator, only two decimal places etc
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
    
    // This method is changing switch status when user presses switch label
    @objc func switchLabelTapped(sender:UITapGestureRecognizer) {
        periodSwitch.setOn(!periodSwitch.isOn, animated: true)
        changeSwitchLabel()
    }
    
    // This method is chaning label text when switch status changed
    func changeSwitchLabel(){
        if periodSwitch.isOn {
            switchLabel.text = "Pay at the beginning of month"
        } else {
            switchLabel.text = "Pay at the end of month"
        }
    }
    
    // Calling changeSwitchLabel() when user changed toggle status
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        changeSwitchLabel()
    }
    
    // Saving textfield and switch data to the user defaults
    @objc func saveFields() {
        defaults.set(futureAmountTF.text, forKey: "savingFutureAmount")
        defaults.set(initialAmountTF.text, forKey: "savingInitialAmount")
        defaults.set(numberOfYearsTF.text, forKey: "savingNumberOfYears")
        defaults.set(interestRateTF.text, forKey: "savingInterestRate")
        defaults.set(paymentAmountTF.text, forKey: "savingPaymentAmount")
        defaults.set(periodSwitch.isOn, forKey: "savingPeriod")
    }
    
    // Reading data from user defaults and setting it to textfields and switch
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
