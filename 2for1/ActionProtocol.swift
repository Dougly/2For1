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
    var turn: Int { get set }
    var dieAdded: Bool { get set }
    
}

extension ActionProtocol {
    
    
    //player actions
    func roll() -> Int {
        for die in dice {
            die.roll()
        }
        return dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
    }
    
    func passDice() -> (turn: Int, player: Player?, drinks: Int) {
        var nextPlayer = player
        
        if turn < players.count {
            nextPlayer = players[turn]
        } else {
            nextPlayer = players[turn % players.count]
        }
        return (turn + 1, nextPlayer, drinks + 1)
    }
    
    
    func rollAddedDie() -> Int {
        dice.last?.roll()
        return dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
    }
    
    func drink(_ action: Action) {
        
    }
    
    func addDie(_ action: Action) {
        
    }
    
    //game responses
    
    
    
}
