//
//  SavingsHelper.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 24/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import Foundation

class SavingsHelper {
    static func futureValueEnd(initialAmount: Double, paymentAmount: Double, interestRate: Double, numberOfYears: Double) -> Double{
        let interest = interestRate / 100
        var one = 1 + (interest / 12)
        one = pow(one, 12 * numberOfYears)
        one = initialAmount * one
        var two = 1 + (interest / 12)
        two = pow(two, 12 * numberOfYears)
        two = two - 1
        two = two / (interest / 12)
        two = paymentAmount * two
        let calculation = one + two
        return calculation
    }
    
    static func futureValueBegin(initialAmount: Double, paymentAmount: Double, interestRate: Double, numberOfYears: Double) -> Double{
        let interest = interestRate / 100
        var one = 1 + (interest / 12)
        one = pow(one, 12 * numberOfYears)
        one = initialAmount * one
        var two = 1 + (interest / 12)
        two = pow(two, 12 * numberOfYears)
        two = two - 1
        two = two / (interest / 12)
        two = paymentAmount * two
        two = two * (1 + (interest / 12))
        let calculation = one + two
        return calculation
    }
    
    static func paymentAmountEnd(initialAmount: Double, futureValue: Double, interestRate: Double, numberOfYears: Double) -> Double{
        let interest = interestRate / 100
        var one = 1 + (interest / 12)
        one = pow(one, 12 * numberOfYears)
        one = initialAmount * one
        var calculation = 1 + (interest / 12)
        calculation = pow(calculation, 12 * numberOfYears)
        calculation = calculation - 1
        calculation = calculation / (interest / 12)
        calculation = (futureValue - one) / calculation
        return calculation
    }
    
    static func paymentAmountBegin(initialAmount: Double, futureValue: Double, interestRate: Double, numberOfYears: Double) -> Double{
        let interest = interestRate / 100
        var one = 1 + (interest / 12)
        one = pow(one, 12 * numberOfYears)
        one = initialAmount * one
        var calculation = 1 + (interest / 12)
        calculation = pow(calculation, 12 * numberOfYears)
        calculation = calculation - 1
        calculation = calculation / (interest / 12)
        calculation = calculation * (1 + (interest / 12))
        calculation = (futureValue - one) / calculation
        return calculation
    }
}
