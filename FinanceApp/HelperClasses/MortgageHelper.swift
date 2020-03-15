//
//  MortgageHelper.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 22/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import Foundation

//
// This class is used to calculate Mortgage values. As method names are self explanatory comments have not been added for each method
//

class MortgageHelper {
    static func paymentAmount(initialAmount: Double, interestRate: Double, numberOfYears: Double) -> Double{
        if (interestRate == 0) {return initialAmount / numberOfYears / 12}
        let part = interestRate / 100 / 12
        var top = pow(1 + part, 12 * numberOfYears)
        top = initialAmount * part * top
        var bottom = pow(1 + part, 12 * numberOfYears)
        bottom = bottom - 1
        let calculation = top / bottom
        return calculation
    }
    
    static func numberOfYears(initialAmount: Double, interestRate: Double, paymentAmount: Double) -> Double{
        if (interestRate == 0) {return initialAmount / paymentAmount / 12}
        let part = interestRate / 100
        var top = initialAmount * part
        top = top - (12 * paymentAmount)
        top = (-12 * paymentAmount) / top
        top = log(top)
        var bottom = (part + 12) / 12
        bottom = 12 * log(bottom)
        let calculation = top / bottom
        return calculation
    }
    
    static func initialValue(paymentAmount: Double, interestRate: Double, numberOfYears: Double) -> Double{
        if (interestRate == 0) {return paymentAmount * numberOfYears * 12}
        let part = interestRate / 100 / 12
        var top = pow(1 + part, 12 * numberOfYears)
        top = top - 1
        top = paymentAmount * top
        var bottom = pow(1 + part, 12 * numberOfYears)
        bottom = part * bottom
        let calculation = top / bottom
        return calculation
    }
}
