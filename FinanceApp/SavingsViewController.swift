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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            break
        case .numberOfYears:
            let result = CompoundHelper.CalculateNumberOfYears(interestRate: interestRate, futureValue: futureValue, initialAmount: initialAmount)
            numberOfYearsTF.text = String(format: "%.2f", result)
            break
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

