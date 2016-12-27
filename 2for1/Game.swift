//
//  Game.swift
//  2for1
//
//  Created by Douglas Galante on 12/25/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

class Game {
    
    var players: [Player] = []
    var player: Player?
    var dice: [Die] = [Die()]
    var playerRoll: Int = 0
    var score: Int = 0
    var drinks: Int = 0
    var action: PlayerAction = .roll
    var turn = 1
    var instructions = ""
    var dieAdded = false {
        didSet {
            if dieAdded == true {
                //notify button view to change
            }
        }
    }
    
    func playerAction() {
        switch self.action {
        case .roll: roll()
        case .addDie: addDie()
        case .rollAddedDie: rollAddedDie()
        case .passDice: passDice()
        case .drink: drink()
        }
   
        switch dieAdded {
        case false:
            if playerRoll == score {
                action = .drink
            } else if playerRoll > score {
                action = .passDice
            } else {
                dieAdded = true
            }
        case true:
            if playerRoll <= score {
                action = .drink
            } else {
                action = .passDice
            }
            dieAdded = false
        }
    }
    
}

//MARK: Player Actions
extension Game {
    
    func roll() {
        for die in dice {
            die.roll()
        }
        playerRoll = dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
    }
    
    
    func passDice() {
        if turn < players.count {
            player = players[turn]
        } else {
            player = players[turn % players.count]
        }
        turn += 1
        drinks += 1
        action = .roll
    }
    
    
    func rollAddedDie() {
        dice.last?.roll()
        playerRoll = dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
    }
    
    func drink() {
        dice = [Die()]
        score = 0
        drinks = 0
        turn = 1
    }
    
    func addDie() {
        dice.append(Die())
        drinks *= 2
    }
    
}




