//
//  Die.swift
//  2for1
//
//  Created by Douglas Galante on 12/25/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

class Die {
    var value: Int = 0
    
    func roll() {
        let randomNum = arc4random_uniform(6) + 1
        value = Int(randomNum)
    }
    
    func myFunc(x: Int, y: Int, equation: (Int, Int) -> Int) -> Int {
        return equation(x, y)
    }
    
    
}
