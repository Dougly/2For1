//
//  Game.swift
//  2for1
//
//  Created by Douglas Galante on 12/25/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

//all functions that manipulate game stats should exist in the game class.
//when buttons are hit on the gameVC they should call functions on the game class and perform appropriate animations

//possible actions on roll: >, <, ==, roll all dice, roll only added die.
//possible other game actions: pass dice, drink, add die, confirm score.

class Game {
    
    var players: [Player] = []
    var player: Player?
    var dice: [Die] = [Die()]
    var isFirstTurn: Bool = true
    var playerRoll: Int = 0
    var score: Int = 0
    var drinks: Int = 0
    var action: PlayerAction = .roll
    var turn: Int = 1
    var instructions: String = ""
    
}

//MARK: Player Actions
extension Game {
    

    func roll() -> (Bool, Bool)? {
        for die in dice {
            die.roll()
        }
        
        playerRoll = dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
        
        if playerRoll < score {
            return (false, false)
        } else if playerRoll == score {
            action = .drink
            return (false, true)
        } else {
            score = playerRoll
            return (true, false)
        }
        
    }
    
    func prepareToPassDice() {
        
    }
    
    
    func passDice() {
        
        if !isFirstTurn {
            drinks += 1
            turn += 1
            score = playerRoll
            if turn < players.count {
                player = players[turn]
            } else {
                player = players[turn % players.count]
            }
        } else {
            isFirstTurn = false
        }
//        instructions = "Pass Dice to \(player!.tag!)"
        action = .roll
    }
    
    
    func rollAddedDie() {
        dice.last?.roll()
        playerRoll = dice.reduce(0) { (result, nextDie) -> Int in
            return result + nextDie.value
        }
        if playerRoll <= score {
            action = .drink
            instructions = "rolled too low... tap to make \(player!.tag!) drink"
        } else {
            instructions = "roll is higher than score... tap to pass the dice"
            action = .passDice
        }
    }
    
    
    func drink() {
        dice = [Die()]
        score = 0
        drinks = 0
        action = .roll
        instructions = "\(player!.tag!) starts the game"
    }
    
    
    func addDie() {
        dice.append(Die())
        drinks *= 2
        action = .rollAddedDie
        instructions = "Extra die added... tap to have \(player!.tag!) roll added die!"
    }
    
}




