//
//  KeyboardView.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 23/02/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import UIKit

protocol KeyboardViewDelegate : class {
    func keyboardButtonPressed(value: Int)
}

class KeyboardView: UIView {

    @IBOutlet var keyboardView: UIView!
    var keyboardViewDelegate : KeyboardViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed("KeyboardView", owner: self, options: nil)
        self.addSubview(keyboardView)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.keyboardViewDelegate?.keyboardButtonPressed(value: sender.tag)
        sender.titleLabel!.text = String(Int(sender.frame.height))
    }
}
