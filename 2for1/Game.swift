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
                instructions = "\(player!) lost and must drink \(drinks) drinks!"
            } else if playerRoll > score {
                action = .passDice
                instructions = "\(player!) rolled high enough. Pass the dice!"
            } else {
                dieAdded = true
                instructions = "\(player!) rolled too low and can add a die or drink!"
            }
        case true:
            if playerRoll <= score {
                action = .drink
                instructions = "\(player!) lost and must drink \(drinks) drinks!"
            } else {
                action = .passDice
                instructions = "\(player!) rolled high enough. Pass the dice!"
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
        score = playerRoll
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




