//
//  Slide.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 04/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

// This protocol is used to be able to controll all pages using Slide type
protocol Slide: UIView {
    var cardView: UIView! {get set}
    func keyboardOpened()
    func keyboardClosed()
}
