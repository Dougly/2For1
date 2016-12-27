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
    var dieAdded = false
    var instructions = ""
    
    func playerAction() {
        switch self.action {
        case .roll:
            playerRoll = roll()
            action = .addDie
        case .addDie:
            dice.append(Die())
            action = .rollAddedDie
        case .rollAddedDie:
            score = rollAddedDie()
            action = .passDice
        case .passDice:
            let turnPlayerDrinks = passDice()
            turn = turnPlayerDrinks.turn
            player = turnPlayerDrinks.player
            drinks = turnPlayerDrinks.drinks
            action = .roll
        case .drink:
            dice = drink()
            score = 0
            drinks = 0
            turn = 1
        }
    }
    
    func gameResponse() {
        if playerRoll == score {
            
        }
    }
    
    
}

//MARK: Player Actions
extension Game {
    
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
    
    
    func drink() -> [Die]{
        return [Die()]
    }
    
}




