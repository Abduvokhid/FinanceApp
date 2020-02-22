//
//  SecondViewController.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 18/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

enum Finding {
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
    
    var finding = Finding.Empty

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func calculatePressed(_ sender: Any) {
        var counter = 0
        
        let futureValue: Double! = Double(futureValueTF.text!)
        if (futureValue == nil) {
            counter += 1
            finding = Finding.FutureValue
        }
        
        let initialAmount: Double! = Double(initialAmountTF.text!)
        if (initialAmount == nil) {
            counter += 1
            finding = Finding.InitialAmount
        }
        
        let numberOfYears: Double! = Double(numberOfYearsTF.text!)
        if (numberOfYears == nil) {
            counter += 1
            finding = Finding.NumberOfYears
        }
        
        let interestRate: Double! = Double(interestRateTF.text!)
        if (interestRate == nil) {
            counter += 1
            finding = Finding.InterestRate
        }
        
        if ((counter == 0 && finding == Finding.Empty) || counter > 1) {
            finding = Finding.Empty
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

