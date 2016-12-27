//
//  ActionProtocol.swift
//  2for1
//
//  Created by Douglas Galante on 12/26/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

protocol ActionProtocol {
    
    var players: [Player] { get set }
    var player: Player? { get set }
    var dice: [Die] { get set }
    var score: Int { get set }
    var drinks: Int { get set }
    var action: Action { get set }
    
}

extension ActionProtocol {
    
    func roll() -> Int {
        for die in dice {
            die.roll()
        }
        return dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
    }
    
    func pass(_ action: Action) {
    
    }
    
    func askToAdd(_ action: Action) {
        
    }
    
    func rollAddedDie(_ action: Action) {
        
    }
    
    func drink(_ action: Action) {
        
    }
    
    func addDie(_ action: Action) {
        
    }
    
}
