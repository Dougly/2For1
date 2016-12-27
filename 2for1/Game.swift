//
//  Game.swift
//  2for1
//
//  Created by Douglas Galante on 12/25/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation

class Game: ActionProtocol {
    
    var players: [Player] = []
    var player: Player?
    var dice: [Die] = [Die()]
    var score: Int = 0
    var drinks: Int = 0
    var action: Action = .roll
    var turn = 1
    var dieAdded = false
    
    func playerAction() {
        switch self.action {
        case .roll:
            score = roll()
            dice.append(Die())
            action = .rollAddedDie
        case .askToAddDie:
            break
        case .addDie:
            break
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
            break
        }
    }
    
    func gameResponse() {
        
    }
    
    
}





