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
    var isFirstTurn: Bool = true
    var playerRoll: Int = 0
    var score: Int = 0
    var drinks: Int = 0
    var action: PlayerAction = .roll
    var turn: Int = 0
    var instructions: String = ""
    
}



//MARK: Player Actions
extension Game {
    
    func roll() -> (wonRoll: Bool, tiedRoll: Bool) {
        for die in dice {
            die.roll()
        }
        
        playerRoll = dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
        
        if playerRoll < score {
            instructions = "\(player!.tag!) rolled too low"
            return (false, false)
        } else if playerRoll == score {
            action = .drink
            return (false, true)
        } else {
            score = playerRoll
            instructions = "\(player!.tag!) rolled high enough!"
            return (true, false)
        }
    }
    
    
    func addDie() {
        dice.append(Die())
        drinks *= 2
        action = .rollAddedDie
        instructions = "\(player!.tag!), roll the added die"
    }
    
    
    func rollAddedDie() -> Bool {
        dice.last?.roll()
        playerRoll = dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
        if playerRoll <= score {
            action = .drink
            return false
        } else {
            action = .roll
            return true
        }
    }
    
    
    func passDice() {
        if !isFirstTurn {
            score = playerRoll
        } else {
            isFirstTurn = false
        }
        
        for die in dice {
            die.value = 0
        }
        playerRoll = 0
        turn += 1
        drinks += 1
        player = players[turn % players.count]
        instructions = "\(player!.tag!)'s turn!"
        action = .roll
    }

    
    func resetGame() {
        dice = [Die()]
        score = 0
        drinks = 0
        playerRoll = 0
        action = .roll
        instructions = "\(player!.tag!) re-starts the game"
    }
    
    
}




