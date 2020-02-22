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

class CompoundViewController: UIViewController {

    @IBOutlet weak var futureValueTF: UITextField!
    @IBOutlet weak var initialAmountTF: UITextField!
    @IBOutlet weak var interestRateTF: UITextField!
    @IBOutlet weak var numberOfYearsTF: UITextField!
    
    var finding = CompoundFinding.Empty
    override func viewDidLoad() {
        super.viewDidLoad()
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

