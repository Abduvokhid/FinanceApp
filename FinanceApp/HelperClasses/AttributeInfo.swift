//
//  AttributeInfo.swift
//  FinanceApp
//
//  Created by Abduvokhid Akhmedov on 11/03/2020.
//  Copyright © 2020 Abduvokhid Akhmedov. All rights reserved.
//

import Foundation

class AttributeInfo {
    
    init(type: Types, start: Int, length: Int) {
        self.type = type
        self.start = start
        self.length = length
    }
    
    enum Types {
        case Normal
        case Bold
    }
    
    let type: Types
    let start: Int
    let length: Int
}
