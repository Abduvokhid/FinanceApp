//
//  CompoundHelper.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 18/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import Foundation

class CompoundHelper {
    
    static func CalculateInterestRate(futureValue: Double, initialAmount: Double, numberOfYears: Double) -> Double {
        var calculation = futureValue / initialAmount
        calculation = pow(calculation, ( 1 / ( 12 * numberOfYears ) ) )
        calculation = (calculation - 1) * 12
        return calculation
    }
    
    static func CalculateFutureValue(interestRate: Double, initialAmount: Double, numberOfYears: Double) -> Double{
        var calculation = 1 + (interestRate / 100 / 12)
        calculation = pow(calculation, 12 * numberOfYears)
        calculation = initialAmount * calculation
        return calculation
    }
    
    static func CalculateInitialAmount(interestRate: Double, futureValue: Double, numberOfYears: Double) -> Double {
        var calculation = 1 + (interestRate / 100 / 12)
        calculation = pow(calculation, 12 * numberOfYears)
        calculation = futureValue / calculation
        return calculation
    }
    
    static func CalculateNumberOfYears(interestRate: Double, futureValue: Double, initialAmount: Double) -> Double {
        let top = log(futureValue / initialAmount)
        let bottom = 12 * log(1 + (interestRate / 100 / 12))
        let calculation: Double = top / bottom
        return calculation
    }
    
}
